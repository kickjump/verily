# ---------------------------------------------------------------------------
# Multi-stage Dockerfile for the Verily Serverpod server.
#
# Build:  docker build -t verily-server .
# Run:    docker run -p 8080:8080 -p 8081:8081 -p 8082:8082 verily-server
# ---------------------------------------------------------------------------

# --- Build stage -----------------------------------------------------------
FROM dart:stable AS build

WORKDIR /app

# Copy workspace root and package manifests first for layer caching.
COPY pubspec.yaml ./
COPY verily_lints/pubspec.yaml verily_lints/pubspec.yaml
COPY verily_core/pubspec.yaml verily_core/pubspec.yaml
COPY verily_client/pubspec.yaml verily_client/pubspec.yaml
COPY verily_server/pubspec.yaml verily_server/pubspec.yaml

# Fetch dependencies (cached unless pubspec files change).
RUN dart pub get

# Copy all source code.
COPY verily_lints/ verily_lints/
COPY verily_core/ verily_core/
COPY verily_client/ verily_client/
COPY verily_server/ verily_server/

# Compile the server to a self-contained native executable.
WORKDIR /app/verily_server
RUN dart compile exe bin/main.dart -o bin/server

# --- Runtime stage ---------------------------------------------------------
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /runtime/ /

WORKDIR /app
COPY --from=build /app/verily_server/bin/server bin/server
COPY --from=build /app/verily_server/config/ config/
COPY --from=build /app/verily_server/generated/ generated/ 2>/dev/null || true
COPY --from=build /app/verily_server/web/ web/ 2>/dev/null || true

EXPOSE 8080 8081 8082

ENTRYPOINT ["/app/bin/server"]
CMD ["--mode", "production", "--server-id", "default", "--logging", "normal", "--role", "monolith"]
