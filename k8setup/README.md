# k8setup - Operation Base

## Create Image

```bash
# Run the `docker buildx ls` command to list the existing builders. This displays the default builder, which is our old builder.
docker buildx ls

# Create a new builder which gives access to the new multi-architecture features.
docker buildx create --name bgcbuilder

### Switch to the new builder and inspect it.
docker buildx use bgcbuilder
docker buildx inspect --bootstrap

# Build the Dockerfile with buildx, passing the list of architectures to build for:
docker buildx build --platform linux/amd64,linux/arm64 --build-arg VERSION_DEFAULT=0.1.29 --build-arg EKSCTL_DEFAULT_VERSION=0.192.0 --build-arg KUBECTL_DEFAULT_VERSION=1.31.0 --build-arg HELM_DEFAULT_VERSION=3.16.2 --build-arg AWSCLI_DEFAULT_VERSION=2.18.7 --build-arg GOLANG_DEFAULT_VERSION=1.23.2 --build-arg TERRAFORM_DEFAULT_VERSION=1.9.7 --build-arg TERRAGRUNT_DEFAULT_VERSION=0.68.2 --build-arg FENIXCLI_DEFAULT_VERSION=1.1.20210707 --build-arg GHOST_DEFAULT_VERSION=1.1.6 --build-arg GHOST_DEFAULT_LNX_BIN_ID=20231207144046 --build-arg VITESS_DEFAULT_VERSION=20.0.2 --build-arg VITESS_DEFAULT_LNX_BIN_ID=2592c59 --build-arg KREW_DEFAULT_LNX_BIN_ID=0.4.4 --build-arg KUBENT_DEFAULT_VERSION=0.7.3 --build-arg HELMDIFF_DEFAULT_VERSION=3.9.11 -t barisgece/k8setup:0.1.29 --push . # or --load .


# Inspect the image using docker buildx imagetools.
docker buildx imagetools inspect barisgece/k8setup:0.1.29

### Delete BUILDX Configuration
docker buildx du # --> Disk Usage
docker buildx ls # --> List builder instances
docker buildx prune -a -f
docker buildx stop [NAME] # --> Stop builder instance
docker buildx rm [NAME] --force # --> Removes the specified or current builder. 
docker buildx rm --all-inactive # --force
```