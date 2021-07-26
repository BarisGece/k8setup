###################################################
# ==================  dropbox  ================== #
###################################################
FROM alpine:edge as dropbox
WORKDIR /dropbox

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

ENV VERSION="${VERSION_DEFAULT:-0.1.6}"
# Note - Latest version of EKSCTL - https://github.com/weaveworks/eksctl/releases
ENV EKSCTL_VERSION="${EKSCTL_DEFAULT_VERSION:-0.58.0}"
# Note - Latest version of KUBECTL - https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION="${KUBECTL_DEFAULT_VERSION:-1.21.3}"
# Note - Latest version of HELM - https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="${HELM_DEFAULT_VERSION:-3.6.3}"
# Note - Latest version of AWS - https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION="${AWSCLI_DEFAULT_VERSION:-2.2.22}"
# Note - Latest version of GOLANG - https://golang.org/doc/install
ENV GOLANG_VERSION="${GOLANG_DEFAULT_VERSION:-1.16.6}"
# Note - Latest version of TERRAFORM - https://github.com/hashicorp/terraform/releases
ENV TERRAFORM_VERSION="${TERRAFORM_DEFAULT_VERSION:-1.0.3}"
# Note - Latest version of TERRAGRUNT - https://github.com/gruntwork-io/terragrunt/releases
ENV TERRAGRUNT_VERSION="${TERRAGRUNT_DEFAULT_VERSION:-0.31.1}"
# Note - Latest version of FENIXCLI - https://github.com/fenixsoft/fenix-cli/releases
ENV FENIXCLI_VERSION="${FENIXCLI_DEFAULT_VERSION:-1.1.20210707}"
# Note - Latest version of GH-OST - https://github.com/github/gh-ost/releases
ENV GHOST_VERSION="${GHOST_DEFAULT_VERSION:-1.1.2}"
ENV GHOST_LNX_BIN_ID="${GHOST_DEFAULT_LNX_BIN_ID:-20210617134741}"
# Note - Latest version of KREW - https://github.com/kubernetes-sigs/krew/releases
ENV KREW_VERSION="${KREW_DEFAULT_VERSION:-0.4.1}"


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

RUN wget -qO - https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz | tar zxvf -

# wget -q https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN wget -qO - https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf -

# wget -O - https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip | unzip -
RUN wget -qO - https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip | unzip -qq -

RUN wget -qO - https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar zxvf -

RUN wget -qO - https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | unzip -qq -

RUN wget -qO terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64

RUN wget -qO fenix-cli https://github.com/fenixsoft/fenix-cli/releases/download/v${FENIXCLI_VERSION}/fenix-cli

RUN wget -qO - https://github.com/github/gh-ost/releases/download/v${GHOST_VERSION}/gh-ost-binary-linux-${GHOST_LNX_BIN_ID}.tar.gz | tar zxvf -

RUN wget -qO - https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew.tar.gz | tar zxvf -

###################################################
# ==================  k8setup  ================== #
###################################################
FROM amazonlinux:2

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

RUN yum update -y && \
  yum upgrade -y && \
  yum install deltarpm git bind-utils wget -y  && \
  yum groupinstall "Development Tools" -y 

# Install python3.8 via aws-linux-extras -> RUN amazon-linux-extras install python3.8=stable -y

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
COPY --from=dropbox  /dropbox/linux-amd64/helm /usr/local/bin
COPY --from=dropbox  /dropbox/aws/ ./aws
COPY --from=dropbox  /dropbox/go/ /usr/local
COPY --from=dropbox  /dropbox/terraform /usr/local/bin
COPY --from=dropbox  /dropbox/terragrunt /usr/local/bin
COPY --from=dropbox  /dropbox/fenix-cli /usr/local/bin
COPY --from=dropbox  /dropbox/gh-ost /usr/local/bin
COPY --from=dropbox  /dropbox/krew-linux_amd64 /usr/local/bin

# Install Krew
RUN chmod +x /usr/local/bin/krew-linux_amd64
RUN krew-linux_amd64 install krew

# ENVs for Krew
ENV KREW_ROOT /root/.krew
ENV PATH $KREW_ROOT/bin:$PATH

# ENVs for Go
ENV GOPATH /usr/local/go
ENV PATH $GOPATH/bin:$PATH

# ENV for jsonnet-bundler -> it is a package manager for Jsonnet.
ENV GO111MODULE "on"

# Releases
## https://github.com/google/go-jsonnet/releases - v0.17.0
## https://github.com/jsonnet-bundler/jsonnet-bundler/releases - v0.4.0
## https://github.com/kubernetes-sigs/kustomize/releases
RUN go get github.com/google/go-jsonnet/cmd/jsonnet && \
  go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb && \
  go get github.com/brancz/gojsontoyaml && \
  go get sigs.k8s.io/kustomize/kustomize/v4

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
RUN kubectl krew install tree

ENTRYPOINT ["/bin/bash"]
