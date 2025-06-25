# Use an official Debian as a base image
FROM debian:buster-slim

ARG FLYWAY_DEFAULT_VERSION
ARG CQLSH_DEFAULT_VERSION
ARG CQLSH_EXPANSION_DEFAULT_VERSION

# Note - Latest version of FLYWAY - https://github.com/flyway/flyway/releases
ENV FLYWAY_VERSION="${FLYWAY_DEFAULT_VERSION:-11.9.2}"
# Note - Latest version of CQLSH - https://pypi.org/project/cqlsh/
ENV CQLSH_VERSION="${CQLSH_DEFAULT_VERSION:-6.2.0}"
# Note - Latest version of CQLSH_EXPANSION - https://pypi.org/project/cqlsh-expansion/
ENV CQLSH_EXPANSION_VERSION="${CQLSH_EXPANSION_DEFAULT_VERSION:-0.9.6}"

# Set environment variables to non-interactive to avoid prompts during installations
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get install -f -y apt-transport-https curl git gnupg2 lsb-release redis-tools

# Install cqlsh
RUN apt-get install python3-pip -y && \
    pip3 install -U cqlsh==${CQLSH_VERSION} && \
    pip3 install cqlsh-expansion==${CQLSH_EXPANSION_VERSION}

RUN cqlsh-expansion.init

# Install Flyway
RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; ARCH="${ARCH##*-}"; \
  case "$ARCH" in \
    'arm64') \
      FLYWAY_ARCH='arm64'; \
      echo There is no arm64 binary;\
      curl -sSL https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-${FLYWAY_ARCH}.tar.gz -o - | tar -xvz;\
      ;; \
    'amd64') \
      FLYWAY_ARCH='x64'; \
      curl -sSL https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-${FLYWAY_ARCH}.tar.gz -o - | tar -xvz;\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

RUN ln -s `pwd`/flyway-${FLYWAY_VERSION}/flyway /usr/local/bin

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify installations
RUN git --version && \
    flyway -v && \
    redis-cli --version && \
    cqlsh --version

# Set default command (this can be changed as needed)
CMD ["bash"]
