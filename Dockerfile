# Multi-stage build for minimal image size
FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN dart pub get

# Copy source code
COPY lib/ lib/

# Generate serialization code
RUN dart pub run build_runner build --delete-conflicting-outputs

# Compile to native executable
RUN dart compile exe lib/main.dart -o todo-api

# Final stage - minimal runtime image
FROM debian:bookworm-slim

# Install only essential runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -r -s /bin/false app

# Copy compiled executable
COPY --from=build /app/todo-api /usr/local/bin/todo-api

# Set ownership and permissions
RUN chown app:app /usr/local/bin/todo-api && chmod +x /usr/local/bin/todo-api

# Switch to non-root user
USER app

# Expose port
EXPOSE 8080

# Run the application
CMD ["/usr/local/bin/todo-api"]