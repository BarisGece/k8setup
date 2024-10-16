# `flyway` - Database Migration Tool

[GitHub](https://github.com/flyway/flyway)

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
docker buildx build --platform linux/amd64 -t barisgece/super-flyway:10.20.0 --push . # or --load .
# docker buildx build --platform linux/amd64,linux/arm64 -t barisgece:super-flyway_10.20.0  --push . # or --load .

# Inspect the image using docker buildx imagetools.
docker buildx imagetools inspect barisgece/super-flyway:10.20.0

### Delete BUILDX Configuration
docker buildx du # --> Disk Usage
docker buildx ls # --> List builder instances
docker buildx prune -a -f
docker buildx stop [NAME] # --> Stop builder instance
docker buildx rm [NAME] --force # --> Removes the specified or current builder. 
docker buildx rm --all-inactive # --force
```
