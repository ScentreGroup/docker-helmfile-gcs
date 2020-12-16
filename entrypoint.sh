#!/bin/sh

helm version
helmfile --version
gcloud version

export GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-/.google-credentials}"
export no_proxy="${no_proxy:-169.254.169.254,metadata,metadata.google.internal}"

if [[ -d $GOOGLE_APPLICATION_CREDENTIALS ]]; then
    echo "$GOOGLE_APPLICATION_CREDENTIALS is a directory, skipping service-account login"
elif [[ -f $GOOGLE_APPLICATION_CREDENTIALS ]]; then
    echo "Found ${GOOGLE_APPLICATION_CREDENTIALS}, performing login."
    gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
else
    echo "${GOOGLE_APPLICATION_CREDENTIALS} not found, using environment authentication."
    unset GOOGLE_APPLICATION_CREDENTIALS
fi

set -euo pipefail

if [ ! -z "${GCP_KUBE_CLUSTER}" ]; then
    gcloud auth list
    gcloud container clusters get-credentials "${GCP_KUBE_CLUSTER}" --region "$GCP_REGION" --project "${GCP_PROJECT}"
fi

exec helmfile $@
