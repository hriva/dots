#!/usr/bin/env bash

alias pip-update="pip list | awk 'NR>2 {print \$1}' | xargs pip install -U"
alias list_python_modules='python -c "import pkgutil; print(\"\\n\".join([mod.name for mod in pkgutil.iter_modules()]))"'
alias create-stubs="list_python_modules | xargs -I{} pyright --createstub {}"

export PYTHON_VENV_DIRS="$HOME"/.local/share/python-venvs

pyenv() {
    # venvs="$(/usr/bin/ls -a "$PYTHON_VENV_DIRS")"
    # if grep -qF "$1" <<<"$venvs"; then
    if [ -d "$PYTHON_VENV_DIRS"/"$1" ]; then
        source "$PYTHON_VENV_DIRS"/"$1"/bin/activate
        return 0
    fi

    echo "Venv $1 not found, avaliable venvs are:"
    /usr/bin/ls -a "$PYTHON_VENV_DIRS"
    return 1
}

pyenv-make() {
    venv_name="$PYTHON_VENV_DIRS"/"$1"
    if [[ ! -d "$venv_name" ]]; then
        python"${2:-"3"}" -m venv "$venv_name"
        source "$venv_name"/bin/activate
        pip install -U setuptools wheel pip
        deactivate
        echo "$venv_name created successfully"
    else
        echo "The $1 environment already exist."
    fi
}

pyenv-make-ls() {
    venv_name="$PYTHON_VENV_DIRS"/"$1"
    if [[ ! -d "$venv_name" ]]; then
        python3.11 -m venv "$venv_name"
        source "$venv_name"/bin/activate
        pip install -U setuptools wheel pip
        deactivate
        echo "$venv_name created successfully"
    else
        echo "The $1 environment already exist."
    fi
}

pyenv-rm() {
    venv_name="$PYTHON_VENV_DIRS"/"$1"
    if [[ -d "$venv_name" ]]; then
        /usr/bin/rm -r "$venv_name"
        echo "The $1 environment has been deleted."
    else
        echo "The $1 environment does not exist."
    fi
}

pyenv-ls() {
    PYTHON_VENV_DIRS="$HOME"/Code/.python_virt_environments
    /usr/bin/ls -a "$PYTHON_VENV_DIRS"
}
