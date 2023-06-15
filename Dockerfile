#####################################################################################################################################
# ===========================================================  dropbox  =========================================================== #
#####################################################################################################################################

# Ubuntu
## DockerHub                                           : https://hub.docker.com/_/ubuntu
## DockerHub Docs Github                               : https://github.com/docker-library/docs/tree/master/ubuntu
## DockerLibrary RepoInfo Github                       : https://github.com/docker-library/repo-info/tree/master/repos/ubuntu
## DockerLibrary OfficalImages Github                  : https://github.com/docker-library/official-images/blob/master/library/ubuntu
## Offical Ubuntu Core tarballs - dist-amd64           : https://github.com/tianon/docker-brew-ubuntu-core/tree/dist-amd64
## Offical Ubuntu Core tarballs - dist-amd64 - focal   : https://github.com/tianon/docker-brew-ubuntu-core/tree/dist-amd64/focal
## Offical Ubuntu Core tarballs - dist-arm64v8         : https://github.com/tianon/docker-brew-ubuntu-core/tree/dist-arm64v8
## Offical Ubuntu Core tarballs - dist-arm64v8 - focal : https://github.com/tianon/docker-brew-ubuntu-core/tree/dist-arm64v8/focal

# Debian
## DockerHub                                              : https://hub.docker.com/_/debian
## DockerHub Docs Github                                  : https://github.com/docker-library/docs/tree/master/debian
## DockerLibrary RepoInfo Github                          : https://github.com/docker-library/repo-info/tree/master/repos/debian
## DockerLibrary OfficalImages Github                     : https://github.com/docker-library/official-images/blob/master/library/debian
## Offical Debian tarballs - dist-amd64                   : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-amd64
## Offical Debian tarballs - dist-amd64 - bullseye        : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-amd64/bullseye
## Offical Debian tarballs - dist-amd64 - bullseye-slim   : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-amd64/bullseye/slim
## Offical Debian tarballs - dist-arm64v8                 : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-arm64v8
## Offical Debian tarballs - dist-arm64v8 - bullseye      : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-arm64v8/bullseye
## Offical Debian tarballs - dist-arm64v8 - bullseye-slim : https://github.com/debuerreotype/docker-debian-artifacts/tree/dist-arm64v8/bullseye/slim

# Pull docker image for different architecture
## docker pull --platform linux/arm64 ubuntu:focal
## docker pull --platform linux/amd64 ubuntu:focal

# Build and run multi-architecture images
## Multi-CPU architecture    : https://docs.docker.com/desktop/multi-arch/
## Docker Buildx             : https://docs.docker.com/buildx/working-with-buildx/
## Docker Buildx Commandline : https://docs.docker.com/engine/reference/commandline/buildx/
### Run the `docker buildx ls` command to list the existing builders. This displays the default builder, which is our old builder.
#### docker buildx ls
### Create a new builder which gives access to the new multi-architecture features.
#### docker buildx create --name bgcbuilder
### Switch to the new builder and inspect it.
#### docker buildx use bgcbuilder
#### docker buildx inspect --bootstrap
### Build the Dockerfile with buildx, passing the list of architectures to build for:
#### docker buildx build --platform linux/amd64,linux/arm64 -t barisgece/k8setup:demo --push or --load.
### Inspect the image using docker buildx imagetools.
#### docker buildx imagetools inspect username/demo:latest

### Delete BUILDX Configuration
#### docker buildx du --> Disk Usage
#### docker buildx ls --> List builder instances
#### docker buildx prune -a -f
#### docker buildx stop [NAME] --> Stop builder instance
#### docker buildx rm [NAME] --force --> Removes the specified or current builder. 
#### docker buildx rm --all-inactive --force

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
ARG KUBENT_DEFAULT_VERSION

ENV VERSION="${VERSION_DEFAULT:-0.1.26}"
# Note - Latest version of EKSCTL - https://github.com/weaveworks/eksctl/releases
ENV EKSCTL_VERSION="${EKSCTL_DEFAULT_VERSION:-0.144.0}"
# Note - Latest version of KUBECTL - https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION="${KUBECTL_DEFAULT_VERSION:-1.27.3}"
# Note - Latest version of HELM - https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="${HELM_DEFAULT_VERSION:-3.12.1}"
# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.12.0}"
# Note - Latest version of GOLANG - https://golang.org/doc/install
ENV GOLANG_VERSION="${GOLANG_DEFAULT_VERSION:-1.20.5}"
# Note - Latest version of TERRAFORM - https://github.com/hashicorp/terraform/releases
ENV TERRAFORM_VERSION="${TERRAFORM_DEFAULT_VERSION:-1.5.0}"
# Note - Latest version of TERRAGRUNT - https://github.com/gruntwork-io/terragrunt/releases
ENV TERRAGRUNT_VERSION="${TERRAGRUNT_DEFAULT_VERSION:-0.46.3}"
# Note - Latest version of FENIXCLI - https://github.com/fenixsoft/fenix-cli/releases
ENV FENIXCLI_VERSION="${FENIXCLI_DEFAULT_VERSION:-1.1.20210707}"
# Note - Latest version of GH-OST - https://github.com/github/gh-ost/releases
ENV GHOST_VERSION="${GHOST_DEFAULT_VERSION:-1.1.5}"
ENV GHOST_LNX_BIN_ID="${GHOST_DEFAULT_LNX_BIN_ID:-20220707162303}"
# Note - Latest version of KREW - https://github.com/kubernetes-sigs/krew/releases
ENV KREW_VERSION="${KREW_DEFAULT_VERSION:-0.4.3}"
# Note - Latest version of KUBENT - https://github.com/doitintl/kube-no-trouble/releases
ENV KUBENT_VERSION="${KUBENT_DEFAULT_VERSION:-0.7.0}"

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
      kubent.version="${KUBENT_VERSION}" \
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
      wget -qO - https://github.com/github/gh-ost/releases/download/v${GHOST_VERSION}/gh-ost-binary-linux-${ARCH}-${GHOST_LNX_BIN_ID}.tar.gz | tar zxvf -; \
      wget -qO - https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCH}.tar.gz | tar zxvf - && mv krew* krew;\
      wget -qO - https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-${ARCH}.tar.gz | tar zxvf -;\
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
      wget -qO - https://github.com/github/gh-ost/releases/download/v${GHOST_VERSION}/gh-ost-binary-linux-amd64-${GHOST_LNX_BIN_ID}.tar.gz | tar zxvf -; \
      wget -qO - https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_${ARCH}.tar.gz | tar zxvf - && mv krew* krew;\
      wget -qO - https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION}-linux-${ARCH}.tar.gz | tar zxvf -;\
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
ARG KUBENT_DEFAULT_VERSION

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
    less \
    vim \
    nano \
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
      kubent.version="${KUBENT_VERSION}" \
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
COPY --from=dropbox  /dropbox/kubent /usr/local/bin

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
## https://github.com/google/go-jsonnet/releases - v0.20.0
## https://github.com/jsonnet-bundler/jsonnet-bundler/releases - v0.5.1
## https://github.com/kubernetes-sigs/kustomize/releases - v5@v5.0.3
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0 && \
  go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@v0.5.1 && \
  go install github.com/brancz/gojsontoyaml@latest && \
  go install sigs.k8s.io/kustomize/kustomize/v5@v5.0.3

RUN chmod -R 755 /aws
RUN /aws/install -i /usr/local/aws-cli -b /usr/local/bin

RUN chmod +x /usr/local/bin/eksctl
RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/helm
RUN chmod +x /usr/local/bin/terraform
RUN chmod +x /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/fenix-cli
RUN chmod +x /usr/local/bin/gh-ost
RUN chmod +x /usr/local/bin/kubent

# Install Kubectl plugins
RUN set -eux; \
  ARCH="$(dpkg --print-architecture)"; ARCH="${ARCH##*-}"; \
  case "$ARCH" in \
    'arm64') \
      wget -qO - https://github.com/ahmetb/kubectl-tree/releases/download/v0.4.3/kubectl-tree_v0.4.3_linux_arm64.tar.gz | tar zxvf -; \
      rm -f LICENSE; \
      mkdir -p ~/.krew/store/tree/v0.4.3; \
      mv kubectl-tree ~/.krew/store/tree/v0.4.3; \
      ln -s /root/.krew/store/tree/v0.4.3/kubectl-tree kubectl-tree; \
      kubectl krew install ctx; \
      kubectl krew install ns; \
      kubectl krew install outdated; \
      ;; \
    'amd64') \
      kubectl krew install tree; \
      kubectl krew install ctx; \
      kubectl krew install ns; \
      kubectl krew install outdated; \
      ;; \
    *) echo >&2 "error: unsupported architecture '$ARCH' (likely packaging update needed)"; exit 1 ;; \
  esac;

ENTRYPOINT ["/bin/bash"]