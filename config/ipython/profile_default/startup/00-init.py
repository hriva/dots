from typing import Any, Union, List

import sys
import traceback

# prevent sum from pyspark.sql.functions from shadowing the builtin sum
builtinSum = sys.modules["builtins"].sum


def logError(function_name: str, e: Union[str, Exception]):
    msg = [function_name]

    if isinstance(e, BaseException):
        msg.append(type(e).__name__)
        # Keep the full traceback, not just str(e) - this is the only record
        # we get of failures caught by logErrorAndContinue, so throwing away
        # the traceback makes them effectively undebuggable.
        msg.append("".join(traceback.format_exception(type(e), e, e.__traceback__)))
    else:
        msg.append("Error")
        msg.append(str(e))

    print(":".join(msg), file=sys.stderr)


# No try/except here: everything below this point (DatabricksMagics, @magics_class,
# etc.) uses these names unconditionally at module-import time, so swallowing an
# ImportError here wouldn't actually make the module importable without IPython -
# it would just delay the inevitable NameError by a few lines. If IPython truly
# isn't installed, failing loudly and immediately here is clearer.
from IPython import get_ipython
from IPython.display import display
from IPython.core.magic import magics_class, Magics, line_magic, needs_local_scope

__disposables = []


def disposable(f):
    if hasattr(f, "__name__"):
        __disposables.append(f.__name__)
    return f


def logErrorAndContinue(f):
    import functools

    @functools.wraps(f)
    def wrapper(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except Exception as e:
            logError(f.__name__, e)

    return wrapper


def find_file_upwards(start_path: str, relative_path: str) -> Union[str, None]:
    """
    Walk upward from start_path (or its containing directory, if it's a file)
    looking for relative_path (a filename, or a nested path like
    ".vscode/settings.json"). Returns the first match found, or None if the
    filesystem root is reached without finding one.
    """
    import os

    curdir = start_path if os.path.isdir(start_path) else os.path.dirname(start_path)
    candidate = os.path.join(curdir, relative_path)
    if os.path.exists(candidate):
        return candidate

    parent = os.path.dirname(curdir)
    if parent == curdir:
        return None
    return find_file_upwards(parent, relative_path)


@logErrorAndContinue
@disposable
def load_env_from_leaf(path: str) -> bool:
    import os

    env_file_path = find_file_upwards(path, ".env")
    if env_file_path is None:
        return False

    with open(env_file_path, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            os.environ[key.strip()] = value.strip().strip('"').strip("'")
    return True


def _strip_jsonc_comments(text: str) -> str:
    """
    Strip // and /* */ comments from VS Code's settings.json (which is JSONC,
    not strict JSON), leaving string contents untouched - a naive regex-based
    stripper would corrupt any value containing "//", e.g. a connection URL
    like "https://...". Also drops trailing commas, which JSONC allows and
    json.loads() does not.
    """
    import re

    out = []
    i, n = 0, len(text)
    in_string = False
    while i < n:
        ch = text[i]
        if in_string:
            out.append(ch)
            if ch == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if ch == '"':
                in_string = False
            i += 1
            continue

        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(ch)
        i += 1

    return re.sub(r",(\s*[}\]])", r"\1", "".join(out))


_VSCODE_VARIABLE_RE = None


def _vscode_variable_re():
    # Compiled lazily so this module has no hard dependency on `re` at
    # import time, consistent with the other helpers' inline imports.
    global _VSCODE_VARIABLE_RE
    if _VSCODE_VARIABLE_RE is None:
        import re

        _VSCODE_VARIABLE_RE = re.compile(r"\$\{(\w+)(?::([^}]*))?\}")
    return _VSCODE_VARIABLE_RE


def _resolve_vscode_variable(match, workspace_folder: str) -> str:
    import os

    var_name, arg = match.group(1), match.group(2)
    if var_name == "workspaceFolder":
        return workspace_folder
    if var_name == "workspaceFolderBasename":
        return os.path.basename(workspace_folder)
    if var_name == "userHome":
        return os.path.expanduser("~")
    if var_name == "env" and arg is not None:
        return os.environ.get(arg, "")
    # Unknown/unsupported variable (${config:...}, ${fileDirname}, etc.) - leave
    # it untouched rather than guessing, so a bad path fails loudly instead of
    # silently resolving to nonsense.
    return match.group(0)


def resolve_vscode_variables(value: Any, workspace_folder: str) -> Any:
    """
    Recursively expands VS Code predefined variables (${workspaceFolder},
    ${workspaceFolderBasename}, ${userHome}, ${env:NAME}) inside the strings
    of a parsed settings.json structure.

    json.loads() has no idea these placeholders exist - only VS Code's own
    extension host resolves them, and only for settings that opt into it
    (sqltools does this internally, which is why the same settings.json works
    fine *inside* VS Code's SQLTools panel). A script that reads
    settings.json directly, like this one, gets the literal, unexpanded
    string back and has to do this substitution itself, or any path built
    with ${workspaceFolder} silently resolves to a bogus relative path
    instead of the real one.
    """
    if isinstance(value, str):
        return _vscode_variable_re().sub(
            lambda m: _resolve_vscode_variable(m, workspace_folder), value
        )
    if isinstance(value, list):
        return [resolve_vscode_variables(v, workspace_folder) for v in value]
    if isinstance(value, dict):
        return {
            k: resolve_vscode_variables(v, workspace_folder) for k, v in value.items()
        }
    return value


@logErrorAndContinue
@disposable
def load_sqltools_connections(path: str) -> List[dict]:
    """
    Finds the nearest .vscode/settings.json walking up from `path` and
    returns its "sqltools.connections" array, with VS Code predefined
    variables (${workspaceFolder}, etc.) expanded, or [] if no such file or
    key exists. Note: only .vscode/settings.json is checked - a multi-root
    *.code-workspace file's own "settings" block is not, since a script
    can't generically know which workspace file is in use.
    """
    import os
    import json

    settings_path = find_file_upwards(path, os.path.join(".vscode", "settings.json"))
    if settings_path is None:
        return []

    with open(settings_path, "r") as f:
        raw = f.read()

    settings = json.loads(_strip_jsonc_comments(raw))
    connections = settings.get("sqltools.connections", [])

    # settings_path is <workspace_folder>/.vscode/settings.json, so its
    # grandparent directory is the folder ${workspaceFolder} refers to.
    workspace_folder = os.path.dirname(os.path.dirname(settings_path))
    return resolve_vscode_variables(connections, workspace_folder)


def select_sql_connection(connections: List[dict]):
    """
    Picks which sqltools connection to use. Returns None if none are
    configured (the caller should fall back to a default local engine).
    Raises ValueError - rather than silently guessing - when there is more
    than one connection and SQL_CONNECTION_NAME isn't set to say which.
    """
    import os

    if not connections:
        return None
    if len(connections) == 1:
        return connections[0]

    names = [c.get("name") for c in connections]
    wanted = os.environ.get("SQL_CONNECTION_NAME")
    if wanted is None:
        raise ValueError(
            "Multiple sqltools connections found ("
            + ", ".join(map(repr, names))
            + "). Set the SQL_CONNECTION_NAME environment variable to one of these names."
        )
    for c in connections:
        if c.get("name") == wanted:
            return c
    raise ValueError(
        f"SQL_CONNECTION_NAME={wanted!r} does not match any configured sqltools "
        f"connection ({', '.join(map(repr, names))})."
    )


def create_engine_for_connection(connection: Union[dict, None]):
    """
    Returns an object exposing .sql(statement) - duckdb.DuckDBPyConnection and
    pyspark.sql.SparkSession both do - used to execute %sql cells.

    connection is None (no sqltools connection configured, or only one and it
    was picked automatically) -> an in-memory DuckDB database. It queries
    local files (Parquet/CSV/JSON) and pandas/Polars DataFrames directly with
    no setup, which covers most exploratory-analytics notebook use without
    needing a server or driver client at all.

    Only "duckdb", "postgres"/"postgresql" and "sqlite" drivers are wired up
    below, via DuckDB's own extensions rather than separate client libraries
    per database - add more `elif driver == ...` branches here as needed
    rather than trying to guess every possible sqltools driver up front.

    Note on credentials: sqltools normally stores connection passwords in
    VS Code's OS keychain, not in settings.json, so they usually aren't
    available to this script. For drivers that need one, set
    SQL_CONNECTION_PASSWORD in the environment (e.g. via .env).
    """
    import os
    import duckdb

    if connection is None:
        return duckdb.connect(database=":memory:")

    driver = str(connection.get("driver", "")).lower()

    if driver == "duckdb":
        return duckdb.connect(database=connection.get("database", ":memory:"))

    if driver in ("postgres", "postgresql"):
        con = duckdb.connect(database=":memory:")
        con.install_extension("postgres")
        con.load_extension("postgres")
        dsn_parts = []
        for conn_key, dsn_key in (
            ("server", "host"),
            ("port", "port"),
            ("database", "dbname"),
            ("username", "user"),
        ):
            if connection.get(conn_key) is not None:
                dsn_parts.append(f"{dsn_key}={connection[conn_key]}")
        password = connection.get("password") or os.environ.get(
            "SQL_CONNECTION_PASSWORD"
        )
        if password:
            dsn_parts.append(f"password={password}")
        con.execute(f"ATTACH '{' '.join(dsn_parts)}' AS pg (TYPE POSTGRES)")
        con.execute("USE pg")
        return con

    if driver == "sqlite":
        con = duckdb.connect(database=":memory:")
        con.install_extension("sqlite")
        con.load_extension("sqlite")
        con.execute(f"ATTACH '{connection['database']}' AS db (TYPE SQLITE)")
        con.execute("USE db")
        return con

    raise NotImplementedError(
        f"No query engine wired up for sqltools driver {connection.get('driver')!r} "
        f"(connection {connection.get('name')!r}). Add a case to "
        f"create_engine_for_connection for it."
    )


@disposable
class EnvLoader:
    transform: type = str

    def __init__(self, env_name: str, default: Any = None, required: bool = False):
        self.env_name = env_name
        self.default = default
        self.required = required

    def __get__(self, instance, owner):
        import os

        if self.env_name in os.environ:
            raw = os.environ[self.env_name]
            if self.transform is not bool:
                return self.transform(raw)

            lowered = raw.lower()
            if lowered in ("true", "1"):
                return True
            if lowered in ("false", "0"):
                return False
            raise ValueError(
                f"Invalid boolean value for environment variable {self.env_name}: {raw!r}"
            )

        if self.required:
            raise AttributeError(
                "Missing required environment variable: " + self.env_name
            )

        return self.default

    def __set__(self, instance, value):
        raise AttributeError(
            "Can't set a value for properties loaded from env: " + self.env_name
        )


@disposable
class LocalDatabricksNotebookConfig:
    # project_root: str = EnvLoader("DATABRICKS_PROJECT_ROOT", default="./")
    dataframe_display_limit: int = EnvLoader("DATABRICKS_DF_DISPLAY_LIMIT", 20)
    show_progress: bool = EnvLoader("SPARK_CONNECT_PROGRESS_BAR_ENABLED", default=False)

    def __new__(cls):
        annotations = cls.__dict__["__annotations__"]
        for attr in annotations:
            cls.__dict__[attr].transform = annotations[attr]
        return object.__new__(cls)


@magics_class
@disposable
class DatabricksMagics(Magics):
    @needs_local_scope
    @line_magic
    def fs(self, line: str, local_ns):
        import shlex

        args = shlex.split(line)
        if len(args) == 0:
            return
        cmd_str = args[0]
        dbutils = local_ns["dbutils"]
        if not hasattr(dbutils.fs, cmd_str):
            raise NameError(
                cmd_str
                + " is not a valid command for %fs. Valid commands are "
                + ", ".join(
                    list(filter(lambda i: not i.startswith("_"), dbutils.fs.__dir__()))
                )
            )
        cmd = dbutils.fs.__getattribute__(cmd_str)
        return cmd(*args[1:])


def is_databricks_notebook(py_file: str) -> bool:
    import os

    if not os.path.exists(py_file):
        return False
    with open(py_file, "r") as f:
        return "Databricks notebook source" in f.readline()


def strip_hash_magic(lines: List[str]) -> List[str]:
    if len(lines) == 0:
        return lines
    if lines[0].startswith("# MAGIC"):
        return [line.partition("# MAGIC ")[2] for line in lines]
    return lines


def convert_databricks_notebook_to_ipynb(py_file: str):
    import os
    import json

    cells: List[dict] = [
        {
            "cell_type": "code",
            "source": "import os\nos.chdir('" + os.path.dirname(py_file) + "')\n",
            "metadata": {},
            "outputs": [],
            "execution_count": None,
        }
    ]
    with open(py_file) as file:
        text = file.read()
        for cell in text.split("# COMMAND ----------"):
            cell = "".join(strip_hash_magic(cell.strip().splitlines(keepends=True)))
            cells.append(
                {
                    "cell_type": "code",
                    "source": cell,
                    "metadata": {},
                    "outputs": [],
                    "execution_count": None,
                }
            )

    return json.dumps(
        {"cells": cells, "metadata": {}, "nbformat": 4, "nbformat_minor": 2}
    )


from contextlib import contextmanager


@contextmanager
def databricks_notebook_exec_env(py_file: str):
    import os
    import sys
    import tempfile

    # Copy the list - `sys.path` is not reassigned here, it's the same object
    # returned every time, so `old_sys_path = sys.path` (without copying) would
    # alias it and the "restore" below would be a no-op, leaking the appended
    # directory onto sys.path permanently.
    old_sys_path = list(sys.path)
    old_cwd = os.getcwd()
    sys.path.append(os.path.dirname(py_file))

    try:
        if is_databricks_notebook(py_file):
            notebook = convert_databricks_notebook_to_ipynb(py_file)
            fd, temp_path = tempfile.mkstemp(suffix=".ipynb")
            with os.fdopen(fd, "wb") as temp_file:
                temp_file.write(notebook.encode())
            try:
                yield temp_path
            finally:
                if os.path.exists(temp_path):
                    os.unlink(temp_path)
        else:
            yield py_file
    finally:
        sys.path[:] = old_sys_path
        os.chdir(old_cwd)


"""
Splits an SQL string into individual statements using recursive descent parsing technique.
Handles semicolons in strings and comments. Most probably breaks in dozens of other edge cases...
"""


class SqlStatementParser:
    def __init__(self, sql):
        self.sql = sql
        self.position = 0
        self.statements = []
        self.current = []

    def parse(self):
        while self.position < len(self.sql):
            char = self.peek()
            next_char = self.peek_next()
            if char == "-" and next_char == "-":
                self.parse_line_comment()
            elif char == "/" and next_char == "*":
                self.parse_block_comment()
            elif char == "'":
                self.parse_string("'")
            elif char == '"':
                self.parse_string('"')
            elif char == "`":
                self.parse_string("`")
            elif char == ";":
                self.position += 1  # Skip the semicolon itself
                self.add_statement()
            else:
                self.consume()
        self.add_statement()  # Add the last statement if there is one
        return self.statements

    def peek(self):
        if self.position < len(self.sql):
            return self.sql[self.position]
        return None

    def peek_next(self):
        if self.position + 1 < len(self.sql):
            return self.sql[self.position + 1]
        return None

    def consume(self):
        char = self.peek()
        if char is not None:
            self.position += 1
            self.current.append(char)
        return char

    def consume_next(self):
        char, next_char = self.peek(), self.peek_next()
        if char is not None and next_char is not None:
            self.position += 2
            self.current.extend([char, next_char])
        return char, next_char

    def add_statement(self):
        if self.current:
            stmt = "".join(self.current).strip()
            if stmt:
                self.statements.append(stmt)
            self.current = []

    def parse_line_comment(self):
        self.consume_next()  # Consume "--" that starts the comment
        while self.peek() is not None:
            if self.peek() == "\n":
                self.consume()
                return
            self.consume()

    def parse_block_comment(self):
        self.consume_next()  # Consume "/*" that starts the comment
        while self.peek() is not None:
            if self.peek() == "*" and self.peek_next() == "/":
                self.consume_next()  # Consume "*/" that ends the comment
                return
            self.consume()
        # A silently-swallowed unterminated comment can eat the rest of the cell
        # (including real statements and their semicolons) with no indication
        # anything went wrong - surface it instead.
        raise ValueError("Unterminated block comment (missing closing */)")

    def parse_string(self, quote_char):
        self.consume()  # Consume the opening quote
        while self.peek() is not None:
            # Handle escaped quote
            if self.peek() == "\\" and self.peek_next() == quote_char:
                self.consume_next()  # Consume the escaped quote
            elif self.peek() == quote_char:
                self.consume()  # Consume the closing quote
                return
            else:
                self.consume()
        # Same reasoning as parse_block_comment: an unterminated string would
        # otherwise silently merge the rest of the cell into one "string".
        raise ValueError(f"Unterminated string literal (missing closing {quote_char})")


@disposable
def create_databricks_magics_transformer(cfg: LocalDatabricksNotebookConfig):
    import os
    import warnings

    def warn_for_dbr_alternative(magic: str):
        # Magics that are not supported on Databricks but work in jupyter notebooks.
        # We show a warning, prompting users to use a databricks equivalent instead.
        local_magic_dbr_alternative = {"%%sh": "sh"}
        if magic in local_magic_dbr_alternative:
            warnings.warn(
                "\n"
                + magic
                + " is not supported on Databricks. This notebook might fail when running on a Databricks cluster.\n"
                "Consider using %" + local_magic_dbr_alternative[magic] + " instead."
            )

    def throw_if_not_supported(magic: str):
        # These are magics that are supported on dbr but not locally.
        unsupported_dbr_magics = ["r", "scala"]
        if magic in unsupported_dbr_magics:
            raise NotImplementedError(
                magic + " is not supported for local Databricks Notebooks."
            )

    def is_cell_magic(lines: List[str]):
        def get_cell_magic(lines: List[str]):
            if len(lines) == 0:
                return
            if lines[0].strip().startswith("%%"):
                return lines[0].split(" ")[0].strip()

        def handle(lines: List[str]):
            cell_magic = get_cell_magic(lines)
            if cell_magic is None:
                return lines
            warn_for_dbr_alternative(cell_magic)
            throw_if_not_supported(cell_magic)
            return lines

        is_cell_magic.handle = handle
        return get_cell_magic(lines) is not None

    def is_line_magic(lines: List[str]):
        def get_line_magic(lines: List[str]):
            if len(lines) == 0:
                return
            if lines[0].strip().startswith("%"):
                return lines[0].split(" ")[0].strip().strip("%")

        def handle(lines: List[str]):
            lmagic = get_line_magic(lines)
            if lmagic is None:
                return lines
            warn_for_dbr_alternative(lmagic)
            throw_if_not_supported(lmagic)

            if lmagic == "md" or lmagic == "md-sandbox":
                lines[0] = "%%markdown" + lines[0].partition("%" + lmagic)[2]
                return lines

            if lmagic == "sh":
                lines[0] = "%%sh" + lines[0].partition("%" + lmagic)[2]
                return lines

            if lmagic == "sql":
                # Capture whatever follows "%sql" on its own line too (e.g.
                # "%sql SELECT 1"), not just later lines - `lines = lines[1:]`
                # used to drop that inline content silently.
                sql_string = lines[0].partition("%" + lmagic)[2] + "".join(lines[1:])
                statements = SqlStatementParser(sql_string).parse()
                result_code = ["global _sqldf\n"]
                for stmt in statements:
                    # repr() correctly escapes quotes/backslashes/newlines for
                    # embedding as a Python string literal - the previous
                    # hand-rolled `.replace("'", "\\'")` + triple-quote wrap
                    # breaks if a statement ever contains `'''`.
                    # `sql_engine` (a duckdb connection by default, or a Spark
                    # session if one was set up) is pushed into this notebook's
                    # namespace by setup() - both expose .sql(statement).
                    result_code.append(f"_sqldf = sql_engine.sql({stmt!r})\n")
                result_code.append("_sqldf")
                return result_code

            if lmagic == "python":
                return lines[1:]

            if lmagic == "run":
                rest = lines[0].strip().split(" ")[1:]
                if len(rest) == 0:
                    return lines

                raw_filename = rest[0]
                # Strip whitespace or possible quotes around the filename
                filename = raw_filename.strip("'\" ")

                for suffix in ["", ".py", ".ipynb", ".ipy"]:
                    if os.path.exists(os.path.join(os.getcwd(), filename + suffix)):
                        filename = filename + suffix
                        break

                return [
                    f"with databricks_notebook_exec_env(r'{filename}') as file:\n",
                    "\t%run -i {file} "
                    + lines[0].partition("%run")[2].partition(raw_filename)[2].strip()
                    + "\n",
                ]

            return lines

        is_line_magic.handle = handle
        return get_line_magic(lines) is not None

    def parse_line_for_databricks_magics(lines: List[str]):
        if len(lines) == 0:
            return lines

        lines_to_ignore = (
            "# Databricks notebook source",
            "# COMMAND ----------",
            "# DBTITLE",
        )
        lines = [line for line in lines if not line.strip().startswith(lines_to_ignore)]
        lines = "".join(lines).strip().splitlines(keepends=True)
        lines = strip_hash_magic(lines)

        for magic_check in [is_cell_magic, is_line_magic]:
            if magic_check(lines):
                return magic_check.handle(lines)

        return lines

    return parse_line_for_databricks_magics


@logErrorAndContinue
@disposable
def register_magics(cfg: LocalDatabricksNotebookConfig):
    ip = get_ipython()
    ip.register_magics(DatabricksMagics)
    ip.input_transformers_cleanup.append(create_databricks_magics_transformer(cfg))


@logErrorAndContinue
@disposable
def register_formatters(notebook_config: LocalDatabricksNotebookConfig):
    def df_html(df):
        return df.limit(notebook_config.dataframe_display_limit).toPandas().to_html()

    def duckdb_relation_html(relation):
        # `sql_engine.sql(...)` (used by the %sql magic and by users directly)
        # returns a duckdb.DuckDBPyRelation for the default - or an explicit
        # "duckdb" sqltools - engine. It has no HTML repr of its own, only a
        # plain-text "duckbox" repr, so without this it always renders as an
        # ASCII table instead of HTML.
        #
        # DuckDB's CLI has a `.mode html` dot command (see
        # https://duckdb.org/docs/lts/clients/cli/output_formats), but dot
        # commands are parsed and rendered by the `duckdb` shell binary
        # itself, not sent to the engine - there's no SQL/PRAGMA equivalent,
        # so it has no bearing on a DuckDBPyRelation used from Python here.
        # Routing through pandas (as already done for pyspark below) is the
        # actual equivalent for this API.
        return relation.limit(notebook_config.dataframe_display_limit).df().to_html()

    html_formatter = get_ipython().display_formatter.formatters["text/html"]

    # pyspark may not be installed at all in a fully engine-agnostic setup, and the
    # Spark Connect DataFrame class lives at a different import path than the
    # classic one. Register a formatter for whichever is actually importable -
    # `DataFrame` was previously referenced here with no import at all, so this
    # always raised NameError and the formatter was never registered.
    try:
        from pyspark.sql import DataFrame as ClassicDataFrame

        html_formatter.for_type(ClassicDataFrame, df_html)
    except ImportError:
        pass
    try:
        from pyspark.sql.connect.dataframe import DataFrame as ConnectDataFrame

        html_formatter.for_type(ConnectDataFrame, df_html)
    except ImportError:
        pass

    # Unlike pyspark, duckdb is a hard dependency here already -
    # create_engine_for_connection() falls back to an in-memory duckdb
    # connection whenever no sqltools connection is configured, so this is
    # the common case, not an optional extra to guard with try/except.
    import duckdb

    html_formatter.for_type(duckdb.DuckDBPyRelation, duckdb_relation_html)


@logErrorAndContinue
@disposable
def register_spark_progress(engine, show_progress: bool):
    # No-ops for anything that isn't a real Spark/Spark-Connect session (e.g.
    # the default DuckDB engine, or None) - these two methods are specific to
    # that API and nothing else exposes them.
    import time

    try:
        import ipywidgets as widgets
    except ImportError:
        return

    if not hasattr(engine, "clearProgressHandlers") or not hasattr(
        engine, "registerProgressHandler"
    ):
        return
    spark = engine

    class Progress:
        SI_BYTE_SIZES = (1 << 60, 1 << 50, 1 << 40, 1 << 30, 1 << 20, 1 << 10, 1)
        SI_BYTE_SUFFIXES = ("EiB", "PiB", "TiB", "GiB", "MiB", "KiB", "B")

        def __init__(self) -> None:
            self._ticks = None
            self._tick = None
            self._started = time.time()
            self._bytes_read = 0
            self._running = 0
            self.init_ui()

        def init_ui(self):
            self.w_progress = widgets.IntProgress(
                value=0, min=0, max=100, bar_style="success", orientation="horizontal"
            )
            self.w_status = widgets.Label(value="")
            if show_progress:
                display(widgets.HBox([self.w_progress, self.w_status]))

        def update_ticks(self, stages, inflight_tasks: int, done: bool) -> None:
            total_tasks = builtinSum(map(lambda x: x.num_tasks, stages))
            completed_tasks = builtinSum(map(lambda x: x.num_completed_tasks, stages))
            if total_tasks > 0:
                self._ticks = total_tasks
                self._tick = completed_tasks
                self._bytes_read = builtinSum(map(lambda x: x.num_bytes_read, stages))

                if done:
                    self._tick = self._ticks
                    self._running = 0

                if self._tick is not None and self._tick >= 0:
                    self.output()
                self._running = inflight_tasks

        def output(self) -> None:
            if self._tick is not None and self._ticks is not None:
                percent_complete = (self._tick / self._ticks) * 100
                elapsed = int(time.time() - self._started)
                scanned = self._bytes_to_string(self._bytes_read)
                running = self._running
                self.w_progress.value = percent_complete
                self.w_status.value = f"{percent_complete:.2f}% Complete ({running} Tasks running, {elapsed}s, Scanned {scanned})"

        @staticmethod
        def _bytes_to_string(size: int) -> str:
            """Helper method to convert a numeric bytes value into a human-readable representation"""
            i = 0
            while (
                i < len(Progress.SI_BYTE_SIZES) - 1
                and size < 2 * Progress.SI_BYTE_SIZES[i]
            ):
                i += 1
            result = float(size) / Progress.SI_BYTE_SIZES[i]
            return f"{result:.1f} {Progress.SI_BYTE_SUFFIXES[i]}"

    class ProgressHandler:
        def __init__(self):
            self.p = None
            self.op_id = ""

        def reset(self):
            self.p = Progress()

        def __call__(self, stages, inflight_tasks: int, operation_id, done: bool):
            if len(stages) == 0:
                return

            if self.op_id != operation_id or not self.p:
                self.op_id = operation_id
                self.reset()

            self.p.update_ticks(stages, inflight_tasks, done)

    spark.clearProgressHandlers()
    spark.registerProgressHandler(ProgressHandler())


@disposable
def make_matplotlib_inline():
    try:
        import matplotlib
    except ImportError:
        return
    get_ipython().run_line_magic("matplotlib", "inline")


@disposable
def setup():
    import os
    import sys

    # Best-effort: proceed with setup regardless of whether a .env file was
    # found. Previously this returned early on failure, silently skipping
    # magic registration, formatters, and spark progress entirely whenever no
    # .env existed anywhere up the directory tree.
    load_env_from_leaf(os.getcwd())

    print(sys.modules[__name__])
    global _sqldf
    # Suppress grpc warnings coming from databricks-connect with newer version of grpcio lib
    os.environ["GRPC_VERBOSITY"] = "NONE"

    cfg = LocalDatabricksNotebookConfig()

    # disable built-in progress bar
    show_progress = cfg.show_progress
    os.environ.pop("SPARK_CONNECT_PROGRESS_BAR_ENABLED", None)

    # Pick a query engine: read VS Code's sqltools.connections if configured,
    # default to an in-memory DuckDB database otherwise. Logged-and-continued
    # rather than fatal, same as the other optional registrations below - but
    # loudly, with a full traceback, since a wrong/ambiguous connection is
    # worth noticing immediately rather than silently querying the wrong
    # database.
    engine = None
    try:
        connections = load_sqltools_connections(os.getcwd()) or []
        connection = select_sql_connection(connections)
        engine = create_engine_for_connection(connection)
    except Exception as e:
        logError("sql engine setup", e)

    if engine is not None:
        get_ipython().push({"sql_engine": engine})

    register_magics(cfg)
    register_formatters(cfg)
    register_spark_progress(engine, show_progress)
    make_matplotlib_inline()

    for name in __disposables + ["__disposables"]:
        globals().pop(name, None)
    globals().pop("disposable", None)


import os

if not os.environ.get("DATABRICKS_EXTENSION_UNIT_TESTS"):
    setup()
