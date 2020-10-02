#!/bin/bash
set -x
if [ -z "$1" ]; then 
    STACK=$(date '+s%Y-%m-%d-%H-%M-%S')
else
    STACK=$1
fi
echo $STACK


gcloud deployment-manager deployments create $STACK --config demo.yaml --project chah-sandbox-np-cah