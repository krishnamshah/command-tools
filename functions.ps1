#!/bin/bash

# opens this file in code
function np { code $profile D:\GITHUB\command-tools\functions.ps1 }

function va {
    # activate virtualenv
    .\venv\Scripts\activate
}

function vb {
    # activate virtualenv
    python -m venv venv
    va
}


function vde {
    # deactivate virtualenv
    deactivate
}


function vup {
    # update pip
    python -m pip install --upgrade pip
}
