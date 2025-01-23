FROM alpine:latest AS build

LABEL org.opencontainers.image.description="FHIR CLI"
LABEL org.opencontainers.image.vendor="Trifork"

ARG hapi_fhir_version

# hadolint ignore=DL3018,DL3007
RUN  apk --no-cache add curl \
  && curl -L --proto "=https" --tlsv1.2 \
    --output hapi-fhir-${hapi_fhir_version}-cli.zip \
    https://github.com/hapifhir/hapi-fhir/releases/download/v${hapi_fhir_version}/hapi-fhir-${hapi_fhir_version}-cli.zip \
  && unzip hapi-fhir-${hapi_fhir_version}-cli.zip

# LTS versions: https://www.oracle.com/java/technologies/java-se-support-roadmap.html
# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/java21:nonroot AS default

COPY --from=build hapi-fhir-cli.jar /app/app.jar

# 65532 is the nonroot user's uid
# used here instead of the name to allow Kubernetes to easily detect that the container
# is running as a non-root (uid != 0) user.
USER 65532:65532
WORKDIR /app
ENV _JAVA_OPTIONS="-XX:MaxRAMPercentage=85.0 -XX:+PrintGC"
CMD ["/app/app.jar", "help"]
