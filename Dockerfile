FROM docker.io/tiredofit/alpine:3.16
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Environment Variables
ENV ENABLE_CRON=FALSE \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    IMAGE_NAME="tiredofit/nginx-proxy-cloudflare-companion" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-nginx-proxy-cloudflare-companion/"

### Dependencies
RUN set -x && \
    apk add -t .npcc-build-deps \
                cargo \
                gcc \
                libffi-dev \
                musl-dev \
                openssl-dev \
                py-pip \
                py3-setuptools \
                py3-wheel \
                python3-dev \
                && \
    \
    apk add -t .npcc-run-deps \
                py3-beautifulsoup4 \
                py3-certifi \
                py3-chardet \
                py3-idna \
                py3-openssl \
                py3-requests \
                py3-soupsieve \
                py3-urllib3 \
                py3-websocket-client \
                py3-yaml \
                python3 \
                && \
    \
    pip install \
            cloudflare==2.19.* \
            get-docker-secret \
            docker[tls] \
            && \
    \
### Cleanup
    apk del .npcc-build-deps && \
    rm -rf /root/.cache /root/.cargo && \
    rm -rf /var/cache/apk/*

### Add Files
ADD install /
