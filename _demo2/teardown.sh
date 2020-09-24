#!/bin/bash
###
# This is the main driver script for tearing down a GCP server from an environment.
# The following parameters are all accepted as either environment variables or
# command flags:
#
# ENV VAR          FLAG  PURPOSE
# ----------------------------------------------------------------------------
# HOST_NAME        -h    The hostname of the server to create.
# PROJECT          -p    The GCP project to create the node in.
# ZONE             -z    The GCP zone to create the node in.
#
###

# any of these can be overriden via environment, or will default to the value listed
HOST_NAME=${HOST_NAME:-laec5009jatst21}
PROJECT=${PROJECT:-cares-np-cah}                                #ID of project (must end with -cah)
ZONE=${ZONE:-us-central1-a}

usage() { echo "Usage: $0 [-h host-name] [-p project-name]" 1>&2; exit 1; }

# all environment variables can be overridden with command-line flags
while getopts ":s:h:p:z:m:e:a:v:" arg; do
    case "${arg}" in
        h)
            HOST_NAME=${OPTARG}
            ;;
        p)
            PROJECT=${OPTARG}
            ;;
        z)
            ZONE=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

#Delete Instance
gcloud compute instances delete $HOST_NAME \
    --zone $ZONE \
    --project $PROJECT \
    --quiet