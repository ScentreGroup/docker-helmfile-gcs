#!/bin/sh

helm version
helmfile --version
gcloud version

GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-/.google-credentials}"

set -euo pipefail

if [[ -d $GOOGLE_APPLICATION_CREDENTIALS ]]; then
    echo "$GOOGLE_APPLICATION_CREDENTIALS is a directory, skipping service-account login"
elif [[ -f $GOOGLE_APPLICATION_CREDENTIALS ]]; then
    echo "Found ${GOOGLE_APPLICATION_CREDENTIALS}, performing login."
    gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
else
    echo "${GOOGLE_APPLICATION_CREDENTIALS} not found, using environment authentication."
fi

if [ ! -z "${GCP_KUBE_CLUSTER}" ]; then
    gcloud container clusters get-credentials "${GCP_KUBE_CLUSTER}" --region "$GCP_REGION" --project "${GCP_PROJECT}"
fi

exec helmfile $@
