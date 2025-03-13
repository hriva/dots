#!/usr/bin/env bash

alias pip-update="pip list | awk 'NR>2 {print \$1}' | xargs pip install -U"
alias list_python_modules='python -c "import pkgutil; print(\"\\n\".join([mod.name for mod in pkgutil.iter_modules()]))"'
alias create-stubs="list_python_modules | xargs -I{} pyright --createstub {}"

pyenv() {
    VENV_DIR="$HOME"/Code/.python_virt_environments
    # venvs="$(/usr/bin/ls -a "$VENV_DIR")"
    # if grep -qF "$1" <<<"$venvs"; then
    if [ -d "$VENV_DIR"/"$1" ]; then
        source "$VENV_DIR"/"$1"/bin/activate
        return 0
    fi

    echo "Venv $1 not found, avaliable venvs are:"
    /usr/bin/ls -a "$VENV_DIR"
    return 1
}

pyenv-make() {
    VENV_DIR="$HOME"/Code/.python_virt_environments
    venv_name="$VENV_DIR"/"$1"
    if [[ ! -d "$venv_name" ]]; then
        python3 -m venv "$venv_name"
        source "$venv_name"/bin/activate
        pip install -U setuptools wheel pip ipython debugpy
        deactivate
        echo "$venv_name created successfully"
    else
        echo "The $1 environment already exist."
    fi
}

pyenv-make-ls() {
    VENV_DIR="$HOME"/Code/.python_virt_environments
    venv_name="$VENV_DIR"/"$1"
    if [[ ! -d "$venv_name" ]]; then
        python3.11 -m venv "$venv_name"
        source "$venv_name"/bin/activate
        pip install -U setuptools wheel pip ipython debugpy
        deactivate
        echo "$venv_name created successfully"
    else
        echo "The $1 environment already exist."
    fi
}

pyenv-rm() {
    VENV_DIR="$HOME"/Code/.python_virt_environments
    venv_name="$VENV_DIR"/"$1"
    if [[ -d "$venv_name" ]]; then
        /usr/bin/rm -r "$venv_name"
        echo "The $1 environment has been deleted."
    else
        echo "The $1 environment does not exist."
    fi
}

pyenv-ls() {
    VENV_DIR="$HOME"/Code/.python_virt_environments
    /usr/bin/ls -a "$VENV_DIR"
}
