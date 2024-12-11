FROM debian:bullseye-slim AS base

# Stage 1: Build (Release) - Compiles the code with optimizations for production
FROM base AS build

# Set environment variables for non-interactive apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies (without coverage and debugging tools)
RUN apt-get update
RUN apt-get install -y build-essential gcc make
RUN rm -rf /var/lib/apt/lists/*

# Create a directory for the project and set it as the working directory
WORKDIR /usr/src/c-boilerplate

# Copy the project files into the container
COPY . .

# Exclude unnecessary files from Docker build context
RUN echo "objects/" >> .dockerignore && \
    echo "*.gcno" >> .dockerignore && \
    echo "*.gcda" >> .dockerignore

# Build the project with release optimizations (no debugging symbols)
RUN make

# Stage 2: Runtime - Only the runtime dependencies and the compiled binary
FROM base AS runtime

# Set environment variables for non-interactive apt-get installs
ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies if needed
RUN apt-get update
RUN apt-get install -y libasan6 libubsan1
RUN rm -rf /var/lib/apt/lists/*

# Ensure the container runs as a non-root user
RUN groupadd -r c-boilerplate && useradd -m -r -g c-boilerplate -m c-boilerplate
USER c-boilerplate

# Copy the compiled binary from the build stage
COPY --from=build --chown=c-boilerplate:c-boilerplate /usr/src/c-boilerplate/c-boilerplate /usr/bin/c-boilerplate

WORKDIR /home/c-boilerplate

# Default command to run the server
CMD ["/usr/bin/c-boilerplate"]
