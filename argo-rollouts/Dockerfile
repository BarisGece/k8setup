####################################################################################################
# Install AWSCLI
####################################################################################################
FROM ubuntu:focal AS awscli

ARG AWSCLI_DEFAULT_VERSION
ARG KUBECTL_DEFAULT_VERSION
ARG KUBECTL_ARGO_ROLLOUTS_DEFAULT_VERSION

# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.27.42}"
# Note - Latest version of KUBECTL - https://dl.k8s.io/release/stable.txt
ENV KUBECTL_VERSION="${KUBECTL_DEFAULT_VERSION:-1.33.2}"
# Note - Latest version of KUBECTL - https://github.com/argoproj/argo-rollouts/releases
ENV KUBECTL_ARGO_ROLLOUTS_VERSION="${KUBECTL_ARGO_ROLLOUTS_DEFAULT_VERSION:-1.8.3}"

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
      wget -qO kubectl-argo-rollouts https://github.com/argoproj/argo-rollouts/releases/download/v${KUBECTL_ARGO_ROLLOUTS_VERSION}/kubectl-argo-rollouts-linux-${ARCH};\
      ;; \
    'amd64') \
      AWSCLI_ARCH='x86_64'; \
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl;\
      wget -qO kubectl-argo-rollouts https://github.com/argoproj/argo-rollouts/releases/download/v${KUBECTL_ARGO_ROLLOUTS_VERSION}/kubectl-argo-rollouts-linux-${ARCH};\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

####################################################################################################
# Final image for Jenkins
# https://quay.io/repository/argoproj/kubectl-argo-rollouts?tab=tags
####################################################################################################
FROM ubuntu:focal
#FROM quay.io/argoproj/kubectl-argo-rollouts:v1.6.0

# Use numeric user, allows kubernetes to identify this user as being
# non-root when we use a security context with runAsNonRoot: true
#USER 999
USER root

COPY --from=awscli  /awscli/aws/ /aws
COPY --from=awscli  /awscli/kubectl /usr/local/bin/
COPY --from=awscli  /awscli/kubectl-argo-rollouts /usr/local/bin/

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl-argo-rollouts

#WORKDIR /home/argo-rollouts

#ENTRYPOINT ["/bin/kubectl-argo-rollouts"]
ENTRYPOINT ["kubectl-argo-rollouts"]

CMD ["dashboard"]
