# hapi-fhir-cli

Repo for building daily releases of the HAPI FHIR CLI if a new version is available.

## Usage

```bash
docker run ghcr.io/trifork/hapi-fhir-cli:latest
```

## Build an older version

This repository only builds the newest version per default, but if you are missing and older version, here is how to do it.

Get a [Personal Access Token](https://github.com/settings/tokens) as described in [this guide](https://documentation.tcs.dev.trifork.dev/tutorials/github-integration/index.html), and login in your terminal.

Then build a local image, test it, and push it to the repository.

```bash
docker build . --build-arg hapi_fhir_version="7.4.5" -t hapi-fhir-cli:7.4.5 -t ghcr.io/trifork/hapi-fhir-cli:7.4.5

docker push ghcr.io/trifork/hapi-fhir-cli:7.4.5
```
