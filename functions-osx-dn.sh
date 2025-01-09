#!/bin/bash


function venv-a {
    if [[ -d "venv" ]]; then
        source venv/bin/activate
    else
        echo "No virtual environment found. Run 'venv-b' to create one."
    fi
}

function venv-b {
    if [[ ! -d "venv" ]]; then
        python -m venv venv
        echo "Virtual environment created."
    fi
    venv-a
}


function np {
    code ~/Github/Krsna/command-tools/functions-osx-dn.sh;
}

function zu {
    source ~/.zshrc
}

