#!/bin/sh

GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS:/.google-credentials}

set -euo pipefail

gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
if [ ! -z "${GKE_CLUSTER_NAME}" ]; then
    gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" --region "$GCP_REGION" --project "${GCP_PROJECT}"
fi

exec helmfile $@
