#!/bin/bash
###
# This is the main driver script for deploying a GCP server to an environment.
# The following parameters are all accepted as either environment variables or
# command flags:
#
# ENV VAR          FLAG  PURPOSE
# ----------------------------------------------------------------------------
# STACK            -s    The GCP Deployment name.
# HOST_NAME        -h    The hostname of the server to create.
# PROJECT          -p    The GCP project to create the node in.
# ZONE             -z    The GCP zone to create the node in.
# MACHINE_TYPE     -m    The instance type of GCP node to create.
# ENVIRONMENT      -e    The GCP environment to create the node in.
# AD_GROUP         -a    The ad group to add to the GCP node as superusers.
# SERVICE_ACCOUNT  -v    The GCP Network Service Account associated with this instance
#
###

# any of these can be overriden via environment, or will default to the value listed
STACK=${STACK:-hybris-$(date '+s%Y-%m-%d-%H-%M-%S')}
HOST_NAME=${HOST_NAME:-laec5009jatst21}
PROJECT=${PROJECT:-chah-sandbox-np}                                
ZONE=${ZONE:-us-central1-a}
MACHINE_TYPE=${MACHINE_TYPE:-n1-standard-1}
ENVIRONMENT=${ENVIRONMENT:-nonprod}
AD_GROUP=${AD_GROUP:-U-HAC-CARES-Hybris-Dev}
SERVICE_ACCOUNT=${SERVICE_ACCOUNT:-cares-np-def}

usage() { echo "Usage: $0 [-s stack] [-h host-name] [-p project-name] [-z zone] [-m machine-type] [-e environment] [-v service-account]" 1>&2; exit 1; }

# all environment variables can be overridden with command-line flags
while getopts ":s:h:p:z:m:e:a:v:" arg; do
    case "${arg}" in
        s)
            STACK=${OPTARG}
            ;;
        h)
            HOST_NAME=${OPTARG}
            ;;
        p)
            PROJECT=${OPTARG}
            ;;
        z)
            ZONE=${OPTARG}
            ;;
        m) 
            MACHINE_TYPE=${OPTARG}
            ;;
        e)
            ENVIRONMENT=${OPTARG}
            ;;
        a)
            AD_GROUP=${OPTARG}
            ;;    
        v)
            SERVICE_ACCOUNT=${OPTARG}
            ;;                   
        *)
            usage
            ;;
    esac
done

# envrionment setup
PATH=$PATH:../../common
export PATH STACK HOST_NAME_PREFIX PROJECT MACHINE_TYPE ENVIRONMENT AD_GROUP ZONE

#Execute Deployment Manager
gcloud deployment-manager deployments create $STACK \
    --template demo-manifest.jinja \
    --properties \
hostName:${HOST_NAME},\
projectId:${PROJECT},\
machineType:${MACHINE_TYPE},\
environment:${ENVIRONMENT},\
serviceAccount:${SERVICE_ACCOUNT},\
adGroup:${AD_GROUP}

# Upload and Execute Remote Setup Script 
envsubst < demo-post-setup.sh | gcssh.bash -s ${HOST_NAME}
