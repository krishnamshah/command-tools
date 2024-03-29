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
