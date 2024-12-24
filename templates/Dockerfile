# Dockerfile Template
################################################################################
# Base image selection
# Choose a base image that matches your application's requirements:
# - Use slim/alpine variants for smaller image sizes
# - Use specific version tags instead of 'latest' for reproducibility
# Examples: node:18-alpine, python:3.11-slim, ubuntu:22.04
################################################################################
FROM ubuntu:22.04 AS builder

################################################################################
# Build-time arguments
# These are only available during image build time, not in the running container
# Use these for version numbers, build configurations, credentials for build time
################################################################################
ARG BUILD_VERSION    # Example: 1.0.0
ARG BUILD_DATE       # Example: $(date -u +'%Y-%m-%dT%H:%M:%SZ')
ARG USER_ID=1000     # Match host user ID for volume permissions
ARG GROUP_ID=1000    # Match host group ID for volume permissions

################################################################################
# Environment variables
# These persist in the running container
# Use these for configuration that should be available at runtime
################################################################################
ENV APP_HOME=/app \           # Application root directory
    NODE_ENV=production \     # Runtime environment
    PORT=3000                # Application port

################################################################################
# Set working directory
# All subsequent commands will run from this directory
################################################################################
WORKDIR $APP_HOME

################################################################################
# System dependencies
# Install only what's necessary for your application
# Clean up cache in the same RUN command to keep layer size small
################################################################################
RUN apt-get update --no-cache && apt-get install -y \
    curl \                    # For health checks and downloads
    git \                     # For version control operations
    build-essential          # Compilation tools
    # && rm -rf /var/lib/apt/lists/*

################################################################################
# User creation for security
# Running containers as non-root is a security best practice
# The user ID and group ID should match your host system if using volumes
################################################################################
RUN groupadd -g $GROUP_ID appuser && \
    useradd -u $USER_ID -g appuser -m -s /bin/bash appuser

################################################################################
# Application code
# Copy application files with appropriate permissions
# Use .dockerignore to exclude unnecessary files
################################################################################
COPY --chown=appuser:appuser . .

################################################################################
# Application build
# Install dependencies and build the application
# Use multi-stage builds to keep final image small
################################################################################
RUN npm ci --production && \
    npm run build

################################################################################
# Production image
# Start fresh with a new base image for the final container
# Copy only necessary files from builder stage
################################################################################
FROM ubuntu:22.04

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/node_modules /app/node_modules

################################################################################
# Security configuration
# Run as non-root user for better security
################################################################################
USER appuser

################################################################################
# Health check
# Configure how Docker should check if your container is healthy
# Format: HEALTHCHECK [OPTIONS] CMD command
# Options:
# --interval=DURATION (default: 30s)
# --timeout=DURATION (default: 30s)
# --retries=N (default: 3)
################################################################################
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:$PORT/health || exit 1

################################################################################
# Image metadata
# Add labels to help with image management
# These are useful for automation and documentation
################################################################################
LABEL maintainer="your-email@example.com" \
      version="$BUILD_VERSION" \
      build-date="$BUILD_DATE"

################################################################################
# Container startup command
# Define the command that runs when the container starts
# Use array syntax for better error handling
################################################################################
CMD ["npm", "start"]
