###################################################
# ==================  dropbox  ================== #
###################################################
FROM ubuntu:focal AS dropbox

ARG AWSCLI_DEFAULT_VERSION
ARG NERDCTL_DEFAULT_VERSION

# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.18.7}"
# Note - Latest version of nerdctl - https://github.com/containerd/nerdctl/releases
ENV NERDCTL_VERSION="${NERDCTL_DEFAULT_VERSION:-1.7.7}"

WORKDIR /dropbox

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
      wget -qO nerdctl.tar.gz https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz;\
      ;; \
    'amd64') \
      AWSCLI_ARCH='x86_64'; \
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -qO nerdctl.tar.gz https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz;\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

RUN tar Czxvf /usr/local/bin/ nerdctl.tar.gz

###################################################
# ==================  nerdctl  ================== #
###################################################
FROM ubuntu:focal

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates

COPY --from=dropbox /dropbox/aws ./aws
COPY --from=dropbox /usr/local/bin/nerdctl /usr/local/bin/nerdctl

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

WORKDIR /home/
