ARG HELMFILE_VERSION=v0.116.0
FROM quay.io/roboll/helmfile:helm3-${HELMFILE_VERSION}
ARG CLOUD_SDK_VERSION=276.0.0
ARG HELM_GCS_VERSION=0.3.0
ARG HELM_VERSION=v3.2.1
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
RUN wget ${HELM_LOCATION}/${HELM_FILENAME} && \
    echo Extracting ${HELM_FILENAME}... && \
    tar zxvf ${HELM_FILENAME} && mv /linux-amd64/helm /usr/local/bin/ && \
    rm ${HELM_FILENAME} && rm -r /linux-amd64

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV CLOUDSDK_PYTHON=python3
ENV HELM_GCS_VERSION=${HELM_GCS_VERSION}
ENV GOOGLE_APPLICATION_CREDENTIALS=/.google-credentials
ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk add python3 && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    helm plugin install https://github.com/hayorov/helm-gcs --version ${HELM_GCS_VERSION}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/* /usr/local/bin/
WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]
