#!/bin/bash

DAPRLOCALSHARED="/Users/`whoami`/.devops"
DAPRLOCALSHARED_COMPONENTS="$DAPRLOCALSHARED/components"

if [[ ! -d $DAPRLOCALSHARED ]]; then
     echo "ERR: Required directory for daprlocalshared $DAPRLOCALSHARED does not exist" 
fi

if [[ ! -d $DAPRLOCALSHARED_COMPONENTS ]]; then
     echo "ERR: Required directory for daprlocalshared components $DAPRLOCALSHARED_COMPONENTS does not exist" 
fi


# alias for kubectl
alias kc=kubectl
alias py=python3
alias python=python3

function az-login() {
    local name="${1:-"airmine"}"
    if [ $name == "airmine" ]; then
        az login --tenant 74dcd7c8-7a0f-447b-84d6-9c74f5990a06
        az account set --subscription "Ironstone-CSP-Airmine-Production"
    elif [ $name == "dcp" ]; then
        az login --tenant 48617d73-72c5-4640-93a2-4e8ffb6bcc25
        az account set --subscription "Azure subscription 1"
    fi
    az account list -o table
}

alias hg='history | grep'
alias get-h='history | grep'


function venv-a {
    # activate virtualenv
    source venv/bin/activate
}

function venv-b {
    # activate virtualenv
    python -m venv venv
    venv-a
    pip-r $1
}

function pip-c {
   pip-compile deploy/requirements.in
}


function np {
    code ~/airmine/tools/functions-osx.sh;
}


function az-airmine {
    az account list -o table
}

# describes the obj with name and type
function kc-ds { kubectl describe $1 $2; }

# lists pods
function kc-p { kubectl get pods; }

# list deployments
function kc-d { kubectl get deployments; }

# swtictches to new prod (Oct 2023)
function kc-p7 { kubectl config use-context aks-airmine-prod-v7; }

# swtictches to new dev (Oct 2023)
function kc-d7 { kubectl config use-context aks-airmine-dev-v7; }

# restarts deployment
function kc-r {
    if [[ -z "$1" ]]; then
        echo "Missing deployment parameter"
    else;
        kubectl rollout restart deployment $1
    fi
}
# list contexts
function kc-l { kubectl config get-contexts; }

# list jobs
function kc-j { kubectl get jobs; }

# list cronjobs
function kc-cj { kubectl get cronjobs; }

# starts browser with dapr dashboard
function dd {
    local port="${1:-8000}"
    dapr dashboard -k -p $port
}

# attaches terminal to pod
function kc-i { kubectl exec --stdin --tty $1 -- /bin/bash; }

function kc-dp { kubectl describe pod $1; }

# # restarts deployment
# function kc-r { kubectl rollout restart deployment $1; }

# forwards to deployment
function kc-f {
    local port="${2:-8002}"
    local target="${3:-8000}"
    kubectl port-forward deployment/$1 $port:$target
}

# forwards to deployment iot-api-dapr 3500:3500
function kc-f3500 {
    local deployment=${1:-"airtable-api"}
    local port="${2:-3500}"
    local target="${3:-3500}"

    kubectl port-forward deployment/$deployment ${port}:${target}
}

# switches to namespace
function kc-n { kubectl config set-context --current --namespace=$1; }

# scales deployment, can be used to scale down to 0
function kc-s { kubectl scale deployment/$1 --replicas $2; }

# switches dapr env by copying local_secrets.* files
function set-env { cp ~/.airmine/local_secrets.json.$1 local_secrets.json; }

# tails deployment logs with stern
function kc-lg { stern $*; }

# tails deployment logs with stern, no dapr container
function kc-lge { stern $* --exclude-container daprd; }

# starts the app in the current folder as a dapr app
function dp_old {
    local port="${1:-8001}"
    local cmd="${2:-'airmine.app:app'}"
    local prm="${3:-"--reload --use-colors --host 0.0.0.0 --log-config log-config.yaml --port "}"
    local app="${4:-"$(basename $PWD)"}"
    local params="dapr run --app-id $app --app-port $port -d components -- uvicorn $cmd $prm $port"
    eval $params
}

# starts the app in the current folder as a dapr app
function dp {
    local folder="${1:-airmine}"
    local app="${2:-`pwd|perl -pe 's|.*/||'`}"
    local port="${3:-8001}"
    local cmd="app:app" 
    local prm="--reload --use-colors --host 0.0.0.0 --log-config log-config.yaml --port"
    local params="dapr run --app-id $app --app-port $port"
    if [[ -d "components" ]]; then
        local params="$params --resources-path components"
    fi
    local params="$params --resources-path $DAPRLOCALSHARED/components"
    local params="$params -- uvicorn $folder.$cmd $prm $port"
    echo "$params"
    eval "$params"
}

function dp-ls {
    local folder="${1:-airmine}"
    local app="${2:-`pwd|perl -pe 's|.*/||'`}"
    local port="${3:-8001}"
    local cmd="app:app" 
    local prm="--reload --use-colors --host 0.0.0.0 --log-config log-config.yaml --port"
    local params="dapr run --app-id $app --app-port $port"
    if [[ -d "components" ]]; then
        local params="$params --resources-path components"
    fi
    local params="$params --resources-path $DAPRLOCALSHARED/components"
    local params="$params -- uvicorn $folder.$cmd $prm $port"
    echo "$params"
}


# shortcut for repo folder
function repo { cd ~/airmine/; }

function flux-r {
    flux reconcile kustomization deployments-policy  --with-source
    flux reconcile kustomization flux-system --with-source
}


function kc-del-failed() { kubectl delete pods --field-selector=status.phase=Failed }
function kc-list-failed() { kubectl get pods --field-selector=status.phase=Failed }
function kc-list-not-running() { kubectl get pods --field-selector=status.phase!=Running }

# install pyton packages
function pip-r {
    local company=$1

    if [[ $1 == 'dcp' ]]; then
         local url="https://github.com/DifferCommunityPower/dcp_common@"
         local file="deploy/dcp_common.version"
    elif [[ $1 == 'airmine' ]]; then
         local url="https://github.com/airmine-ai/airmine-python@"
         local file="deploy/airmine_pkg.version"
    else
         echo "Unrecognized: $company"
         return
    fi

    COMMON_VERSION=`cat $file|cut -d"=" -f2`
    eval "pip install -r deploy/requirements.txt"
    eval "pip install "git+$url$COMMON_VERSION""
    eval "pip install -r deploy/requirements-local.txt"
}



function set-env-old {
    readonly env=${1:?"Environment must be dev or prod"}
    cp ~/.airmine/local_secrets.json.$env local_secrets.json;

}

# switches dapr env by copying local_secrets.* files 
function set-env() { 
    local env=$1
    local envfile="$DAPRLOCALSHARED/local_secrets.json.$env"
    if [[ -f $envfile ]]; then
        local target="$DAPRLOCALSHARED/local_secrets.json"
        copy=`cp -pv $envfile $target`
        local context=`cat $target|perl -e 'while (<>) { print $1 if /"context".*?:.*?"(.*?)"/;}'`
        k8s=`kubectl config use-context $context`
        echo "Set environment:\n\t > env=$env \n\t > $copy\n\t > $k8s\n"
        kc-l
    else
        echo "Environment file $envfile not found"
    fi
}

function get-env { 
    local target="$DAPRLOCALSHARED/local_secrets.json"
    if [[ -f "$target" ]]; then
        local env=`cat $target|perl -e 'while (<>) { print $1 if /"env".*?:.*?"(.*?)"/;}'`
        echo "\nDapr environment=$env\nKubernetes="

        kc-l
    else
        echo "File $target not found"
    fi
}

function list-env { 
    echo "$DAPRLOCALSHARED="
    ls $DAPRLOCALSHARED|sed "s/^/\t"/
    get-env
}