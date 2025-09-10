# HAPI FHIR CLI

Repo for building daily releases of the HAPI FHIR CLI if a new version is available. Do not be fooled by the low commit activity in the repo. Instead, see the tags provided on https://github.com/trifork/hapi-fhir-cli/tags. If you find a missing release or encounter bugs, please do make an issue.

## Usage

This image is a distroless image, which means there is no `sh` or `bash` to configure it with.
The image will launch `./app.jar` on startup, and can only be modified with commands on startup.

### Inline

Unless you configure a lot of shell variables, you must write what you want directly in the shell:

```bash
docker run --rm ghcr.io/trifork/hapi-fhir-cli:latest app.jar migrate-database \
    -d POSTGRES_9_4 \
    -u jdbc:postgresql://127.0.0.1:5432/postgres \
    -n myUser \
    -p myPassword
```

### Docker Compose

For a Docker Compose setup, you can have a `.env`-file with with variables in, and refer them in `command`, as this will substitute them in before the container starts up.

```yaml
services:

  hapi_fhir_cli:
    container_name: "HAPI-FHIR-CLI"
    image: ghcr.io/trifork/hapi-fhir-cli:latest
    depends_on:
      - hapi
    command: "app.jar migrate-database \
      -d POSTGRES_9_4 \
      -u jdbc:postgresql://${DB_URL}:${DB_PORT}/${DB_NAME} \
      -n ${DB_USERNAME} \
      -p ${DB_PASSWORD}"
```

### Kubernetes Job

When spinning up a job in Kubernetes, you can still use secret and variables, but they are still passed in through `command`.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hapi-fhir-cli
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: hapi-fhir-cli
          image: ghcr.io/trifork/hapi-fhir-cli:latest # Remember to specify version
          command: ["app.jar"]
          args: ["migrate-database -d POSTGRES_9_4 -u jdbc:postgresql://${DB_URL}:${DB_PORT}/${DB_NAME} -n ${DB_USERNAME} -p ${DB_PASSWORD}"]
          env:
            - name: DB_URL
              valueFrom:
                configMapKeyRef:
                  name: config-map-name
                  key: DB_CONN

            - name: DB_PORT
              valueFrom:
                configMapKeyRef:
                  name: config-map-name
                  key: DB_PORT

            - name: DB_NAME
              valueFrom:
                secretKeyRef:
                  name: secret-name
                  key: POSTGRES_DB

            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: secret-name
                  key: POSTGRES_USER

            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: secret-name
                  key: POSTGRES_PASSWORD

          securityContext:
            runAsUser: 5050
            runAsGroup: 5050
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - "ALL"
```

## Build an older version

This repository only builds the newest version per default, but if you are missing and older version, either create an issue here, or push to your own container registry.

Login to Docker using `docker login` for your container registry of choice.
For GitHub, get a [Personal Access Token](https://github.com/settings/tokens) with both the scopes `write:packages` and `read:packages`, and [login in your terminal](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

Then build a local image, test it, and push it to the repository.

```bash
# Create an image to use with inline or Docker Compose
docker build . --build-arg hapi_fhir_version="7.4.5" -t hapi-fhir-cli:7.4.5

# Create an image for a Container Registry
docker build . --build-arg hapi_fhir_version="7.4.5" -t ghcr.io/trifork/hapi-fhir-cli:7.4.5

# Push to Container Registry
docker push ghcr.io/trifork/hapi-fhir-cli:7.4.5
```
