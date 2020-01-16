FROM quay.io/roboll/helmfile:v0.98.2
ARG CLOUD_SDK_VERSION=276.0.0
ARG HELM_VERSION=2.11.0

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV CLOUDSDK_PYTHON=python3
ENV HELM_VERSION=$HELM_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk add python3 && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz |tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm plugin install https://github.com/viglesiasce/helm-gcs.git --version v0.2.0

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]
