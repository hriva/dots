#!/usr/bin/env bash

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
