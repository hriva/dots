#!/usr/bin/env bash

alias pip-update="pip list | awk 'NR>2 {print $1}' | xargs pip install -U"
alias list_python_modules='python -c "import pkgutil; print(\"\\n\".join([mod.name for mod in pkgutil.iter_modules()]))"'
alias create-stubs="list_python_modules | xargs -I{} pyright --createstub {}"

pyenv() {
    VENV_DIR="$HOME/Code"
    case $1 in
    main)
        source "$VENV_DIR/.devel-env/bin/activate"
        ;;
    main311)
        source "$VENV_DIR/.devel-env-311/bin/activate"
        ;;
    # Add more cases for additional environments
    *)
        echo "Error: Python environment with name $1 not found"
        ;;
    esac
}
