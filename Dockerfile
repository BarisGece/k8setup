###################################################
# ==================  dropbox  ================== #
###################################################
FROM ubuntu:focal as dropbox

ARG VERSION_DEFAULT
ARG EKSCTL_DEFAULT_VERSION
ARG KUBECTL_DEFAULT_VERSION
ARG HELM_DEFAULT_VERSION
ARG AWSCLI_DEFAULT_VERSION
ARG GOLANG_DEFAULT_VERSION
ARG TERRAFORM_DEFAULT_VERSION
ARG TERRAGRUNT_DEFAULT_VERSION
ARG FENIXCLI_DEFAULT_VERSION
ARG GHOST_DEFAULT_VERSION
ARG GHOST_DEFAULT_LNX_BIN_ID
ARG KREW_DEFAULT_VERSION

ENV VERSION="${VERSION_DEFAULT:-0.1.10}"
# Note - Latest version of EKSCTL - https://github.com/weaveworks/eksctl/releases
ENV EKSCTL_VERSION="${EKSCTL_DEFAULT_VERSION:-0.91.0}"
# Note - Latest version of KUBECTL - https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION="${KUBECTL_DEFAULT_VERSION:-1.23.5}"
# Note - Latest version of HELM - https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="${HELM_DEFAULT_VERSION:-3.8.1}"
# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.5.2}"
# Note - Latest version of GOLANG - https://golang.org/doc/install
ENV GOLANG_VERSION="${GOLANG_DEFAULT_VERSION:-1.18}"
# Note - Latest version of TERRAFORM - https://github.com/hashicorp/terraform/releases
ENV TERRAFORM_VERSION="${TERRAFORM_DEFAULT_VERSION:-1.1.7}"
# Note - Latest version of TERRAGRUNT - https://github.com/gruntwork-io/terragrunt/releases
ENV TERRAGRUNT_VERSION="${TERRAGRUNT_DEFAULT_VERSION:-0.36.6}"
# Note - Latest version of FENIXCLI - https://github.com/fenixsoft/fenix-cli/releases
ENV FENIXCLI_VERSION="${FENIXCLI_DEFAULT_VERSION:-1.1.20210707}"
# Note - Latest version of GH-OST - https://github.com/github/gh-ost/releases
ENV GHOST_VERSION="${GHOST_DEFAULT_VERSION:-1.1.3}"
ENV GHOST_LNX_BIN_ID="${GHOST_DEFAULT_LNX_BIN_ID:-20220225143057}"
# Note - Latest version of KREW - https://github.com/kubernetes-sigs/krew/releases
ENV KREW_VERSION="${KREW_DEFAULT_VERSION:-0.4.3}"

LABEL maintainer="baris@dreamgames.com" \
      eksctl.version="${EKSCTL_VERSION}" \
      kubectl.version="${KUBECTL_VERSION}" \
      helm.version="${HELM_VERSION}" \
      awscli.version="${AWSCLI_VERSION}" \
      golang.version="${GOLANG_VERSION}" \
      terraform.version="${TERRAFORM_VERSION}" \
      terragrunt.version="${TERRAGRUNT_VERSION}" \
      fenixcli.version="${FENIXCLI_VERSION}" \
      ghost.version="${GHOST_VERSION}" \
      ghostlinuxbin.id="${GHOST_LNX_BIN_ID}" \
      krew.version="${KREW_VERSION}" \
      description="dropbox image" \
      version="${VERSION}"

WORKDIR /dropbox

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    netbase \
    wget \
    git \
    openssh-client \
    procps \
    unzip \
    ; \
  rm -rf /var/lib/apt/lists/*

RUN set -ex; \
  if ! command -v gpg > /dev/null; then \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      gnupg \
      dirmngr \
    ; \
    rm -rf /var/lib/apt/lists/*; \
  fi

RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; ARCH="${ARCH##*-}"; \
  case "$ARCH" in \
    'arm64') \
      AWSCLI_ARCH='aarch64'; \
      wget -qO - https://github.com/weaveworks/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_${ARCH}.tar.gz | tar zxvf -;\
      wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl;\
      wget -qO - https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar zxvf - --strip-components=1;\
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -qO - https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz | tar zxvf -;\
      wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && unzip -qq terraform.zip;\
      wget -qO terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${ARCH};\
      wget -qO fenix-cli https://github.com/fenixsoft/fenix-cli/releases/download/v${FENIXCLI_VERSION}/fenix-cli;\
      wget -qO - https://github.com/github/gh-ost/releases/download/v${GHOST_VERSION}/gh-ost-binary-linux-${GHOST_LNX_BIN_ID}.tar.gz | tar zxvf -; \
      wget -qO - https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCH}.tar.gz | tar zxvf - && mv krew* krew;\
      ;; \
    'amd64') \
      AWSCLI_ARCH='x86_64'; \
      wget -qO - https://github.com/weaveworks/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_${ARCH}.tar.gz | tar zxvf -;\
      wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl;\
      wget -qO - https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar zxvf - --strip-components=1;\
      wget -qO awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip && unzip -qq awscli.zip;\
      wget -qO - https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz | tar zxvf -;\
      wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && unzip -qq terraform.zip;\
      wget -qO terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${ARCH};\
      wget -qO fenix-cli https://github.com/fenixsoft/fenix-cli/releases/download/v${FENIXCLI_VERSION}/fenix-cli;\
      wget -qO - https://github.com/github/gh-ost/releases/download/v${GHOST_VERSION}/gh-ost-binary-linux-${GHOST_LNX_BIN_ID}.tar.gz | tar zxvf -; \
      wget -qO - https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCH}.tar.gz | tar zxvf - && mv krew* krew;\
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

###################################################
# ==================  k8setup  ================== #
###################################################
FROM ubuntu:focal

ARG VERSION_DEFAULT
ARG EKSCTL_DEFAULT_VERSION
ARG KUBECTL_DEFAULT_VERSION
ARG HELM_DEFAULT_VERSION
ARG AWSCLI_DEFAULT_VERSION
ARG GOLANG_DEFAULT_VERSION
ARG TERRAFORM_DEFAULT_VERSION
ARG TERRAGRUNT_DEFAULT_VERSION
ARG FENIXCLI_DEFAULT_VERSION
ARG GHOST_DEFAULT_VERSION
ARG GHOST_DEFAULT_LNX_BIN_ID
ARG KREW_DEFAULT_VERSION

RUN set -eux; \
  apt-get update; \
  apt-get full-upgrade -y;\
  apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    netbase \
    build-essential \
    wget \
    git \
    openssh-client \
    procps \
    unzip \
    ; \
  rm -rf /var/lib/apt/lists/*

RUN set -ex; \
  if ! command -v gpg > /dev/null; then \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      gnupg \
      dirmngr \
    ; \
    rm -rf /var/lib/apt/lists/*; \
  fi

LABEL maintainer="baris@dreamgames.com" \
      eksctl.version="${EKSCTL_DEFAULT_VERSION}" \
      kubectl.version="${KUBECTL_DEFAULT_VERSION}" \
      helm.version="${HELM_DEFAULT_VERSION}" \
      awscli.version="${AWSCLI_DEFAULT_VERSION}" \
      golang.version="${GOLANG_VERSION}" \
      terraform.version="${TERRAFORM_DEFAULT_VERSION}" \
      terragrunt.version="${TERRAGRUNT_DEFAULT_VERSION}" \
      fenixcli.version="${FENIXCLI_DEFAULT_VERSION}" \
      ghost.version="${GHOST_DEFAULT_VERSION}" \
      ghostlinuxbin.id="${GHOST_DEFAULT_LNX_BIN_ID}" \
      krew.version="${KREW_VERSION}" \
      description="k8setup image" \
      version="${VERSION_DEFAULT}"

COPY --from=dropbox  /dropbox/eksctl /usr/local/bin
COPY --from=dropbox  /dropbox/kubectl /usr/local/bin
COPY --from=dropbox  /dropbox/helm /usr/local/bin
COPY --from=dropbox  /dropbox/aws/ ./aws
COPY --from=dropbox  /dropbox/go/ /usr/local
COPY --from=dropbox  /dropbox/terraform /usr/local/bin
COPY --from=dropbox  /dropbox/terragrunt /usr/local/bin
COPY --from=dropbox  /dropbox/fenix-cli /usr/local/bin
COPY --from=dropbox  /dropbox/gh-ost /usr/local/bin
COPY --from=dropbox  /dropbox/krew /usr/local/bin

# Install Krew
RUN chmod +x /usr/local/bin/krew
RUN krew install krew

# ENVs for Krew
ENV KREW_ROOT /root/.krew
ENV PATH $KREW_ROOT/bin:$PATH

# ENVs for Go
ENV GOPATH /usr/local/go
ENV PATH $GOPATH/bin:$PATH

# ENV for jsonnet-bundler -> it is a package manager for Jsonnet.
ENV GO111MODULE "on"

# Releases
## https://github.com/google/go-jsonnet/releases - v0.18.0
## https://github.com/jsonnet-bundler/jsonnet-bundler/releases - v0.4.0
## https://github.com/kubernetes-sigs/kustomize/releases - v4.5.4
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@v0.18.0 && \
  go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.4.0 && \
  go install github.com/brancz/gojsontoyaml@latest && \
  go install sigs.k8s.io/kustomize/kustomize/v4@v4.5.4

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

RUN chmod +x /usr/local/bin/eksctl
RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/helm
RUN chmod +x /usr/local/bin/terraform
RUN chmod +x /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/fenix-cli
RUN chmod +x /usr/local/bin/gh-ost

# Install Kubectl plugins
RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; ARCH="${ARCH##*-}"; \
  case "$ARCH" in \
    'arm64') \
      wget -qO - https://github.com/ahmetb/kubectl-tree/releases/download/v0.4.1/kubectl-tree_v0.4.1_linux_arm64.tar.gz | tar zxvf -; \
      rm -f LICENSE; \
      mkdir -p ~/.krew/store/tree/v0.4.1; \
      mv kubectl-tree ~/.krew/store/tree/v0.4.1; \
      ln -s /root/.krew/store/tree/v0.4.1/kubectl-tree kubectl-tree; \
      ;; \
    'amd64') \
      kubectl krew install tree; \
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

ENTRYPOINT ["/bin/bash"]