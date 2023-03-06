###################################################
# ==================  dropbox  ================== #
###################################################
FROM ubuntu:focal as dropbox

ARG AWSCLI_DEFAULT_VERSION
ARG NERDCTL_DEFAULT_VERSION

# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.11.0}"
# Note - Latest version of nerdctl - https://github.com/containerd/nerdctl/releases
ENV NERDCTL_VERSION="${NERDCTL_DEFAULT_VERSION:-1.2.1}"

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
      ;; \
    'amd64') \
      AWSCLI_ARCH='x86_64'; \
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

RUN wget "https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz"

RUN tar Czxvf /usr/local/bin/ nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz


###################################################
# ==================  nerdctl  ================== #
###################################################
FROM ubuntu:focal

COPY --from=dropbox /dropbox/aws ./aws
COPY --from=dropbox /usr/local/bin/nerdctl /usr/local/bin/nerdctl

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

WORKDIR /home/
