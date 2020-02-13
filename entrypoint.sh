#!/bin/sh

GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-/.google-credentials}"

set -euo pipefail

gcloud auth activate-service-account --key-file "${GOOGLE_APPLICATION_CREDENTIALS}"
if [ ! -z "${GCP_KUBE_CLUSTER}" ]; then
    gcloud container clusters get-credentials "${GCP_KUBE_CLUSTER}" --region "$GCP_REGION" --project "${GCP_PROJECT}"
fi

exec helmfile $@
