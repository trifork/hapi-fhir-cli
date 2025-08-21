# HAPI FHIR CLI

Repo for building daily releases of the HAPI FHIR CLI if a new version is available. Do not be fooled by the low commit activity in the repo. Instead, see the tags provided on https://github.com/trifork/hapi-fhir-cli/tags. If you find a missing release or encounter bugs, please do make an issue.

## Usage

### Inline

```bash
docker run ghcr.io/trifork/hapi-fhir-cli:latest
```

### New image usage

```dockerfile
FROM ghcr.io/trifork/hapi-fhir-cli:latest AS Final

ENV DATABASE_DRIVER=POSTGRES_9_4
ENV JDBC_DIALECT=jdbc:postgresql
ENV DB_PORT=5432
ENV DB_USER=""
ENV DB_PASSWORD=""
ENV DB_DATABASE=""
ENV DB_URL=""
ENV EXTRA_ARGS="--dry-run"

ENTRYPOINT ["sh",  "-c", "./hapi-fhir-cli migrate-database -d ${DATABASE_DRIVER} -u ${JDBC_DIALECT}://${DB_URL}:${DB_PORT}/${DB_DATABASE} -n ${DB_USER} -p ${DB_PASSWORD} ${EXTRA_ARGS}"]

```

## Build an older version

This repository only builds the newest version per default, but if you are missing and older version, either create an issue here, or push to your own container registry.

Login to Docker using `docker login` for your container registry of choice.
For GitHub, get a [Personal Access Token](https://github.com/settings/tokens) with both the scopes `write:packages` abd `read:packages`, and [login in your terminal](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Then build a local image, test it, and push it to the repository.

```bash
docker build . --build-arg hapi_fhir_version="7.4.5" -t hapi-fhir-cli:7.4.5 # Local image
docker build . --build-arg hapi_fhir_version="7.4.5" -t ghcr.io/trifork/hapi-fhir-cli:7.4.5 # Tag for GitHub, when pushing for this repository's Container Registry

#docker push <tag>
docker push ghcr.io/trifork/hapi-fhir-cli:7.4.5
```
