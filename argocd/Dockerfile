####################################################################################################
# Install AWSCLI & KUBECTL & ARGOCD
####################################################################################################
FROM ubuntu:noble AS awscli

ARG AWSCLI_DEFAULT_VERSION
ARG KUBECTL_DEFAULT_VERSION
ARG ARGOCD_DEFAULT_VERSION

# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.18.7}"
# Note - Latest version of KUBECTL - https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION="${KUBECTL_DEFAULT_VERSION:-1.31.0}"
# Note - Latest version of KUBECTL - https://github.com/argoproj/argo-rollouts/releases
ENV ARGOCD_VERSION="${ARGOCD_DEFAULT_VERSION:-2.12.4}"

WORKDIR /awscli

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    unzip \
    ; \
  rm -rf /var/lib/apt/lists/*

RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; ARCH="${ARCH##*-}"; \
  case "$ARCH" in \
    'arm64') \
      AWSCLI_ARCH='aarch64'; \
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl;\
      wget -qO argocd https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCH};\
      ;; \
    'amd64') \
      AWSCLI_ARCH='x86_64'; \
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl;\
      wget -qO argocd https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-${ARCH};\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

####################################################################################################
# Final image for Jenkins
# https://argo-cd.readthedocs.io/en/stable/cli_installation/#download-latest-version
####################################################################################################
FROM ubuntu:noble
USER root

COPY --from=awscli  /awscli/aws/ /aws
COPY --from=awscli  /awscli/kubectl /usr/local/bin/
COPY --from=awscli  /awscli/argocd /usr/local/bin/

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/argocd

ENTRYPOINT ["/bin/bash"]