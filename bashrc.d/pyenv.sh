#!/usr/bin/env bash

alias pip-update="pip list | awk 'NR>2 {print $1}' | xargs pip install -U"
alias list_python_modules='python -c "import pkgutil; print(\"\\n\".join([mod.name for mod in pkgutil.iter_modules()]))"'
alias create-stubs="list_python_modules | xargs -I{} pyright --createstub {}"

pyenv() {
    VENV_DIR="$HOME"/Code
    case $1 in
    main)
        source "$VENV_DIR"/.devel-env/bin/activate
        ;;
    main311)
        source "$VENV_DIR"/.devel-env-311/bin/activate
        ;;
    tmp)
        if [ -d "$VENV_DIR"/tmp ]; then
            source "$VENV_DIR"/tmp/bin/activate
        else
            pyenv-make tmp
            source "$VENV_DIR"/tmp/bin/activate
            echo "tmp created..."
        fi
        ;;
    # Add more cases for additional environments
    *)
        echo "Error: Python environment with name $1 not found"
        ;;
    esac
}

pyenv-make() {
    VENV_DIR="$HOME"/Code
    venv_name="$VENV_DIR"/"${1}"
    python3 -m venv "$venv_name"
    source "$venv_name"/bin/activate
    pip install -U setuptools wheel pip
    deactivate
    echo "$venv_name created successfully"
}

pyenv-clear() {
    VENV_DIR="$HOME"/Code
    venv_name="$VENV_DIR"/tmp
    if [ -d "$venv_name" ]; then
        rm -rf "$venv_name"
        echo "The 'tmp' environment has been deleted."
    else
        echo "The 'tmp' environment does not exist."
    fi
}
