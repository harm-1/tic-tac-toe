# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG NODE_VERSION=23.0.0

FROM node:${NODE_VERSION}-alpine AS builder

# Use production node environment by default.
ENV NODE_ENV production

WORKDIR /app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# Leverage a bind mounts to package.json and package-lock.json to avoid having to copy them into
# into this layer.
COPY package.json ./
RUN npm install
RUN mkdir -p node_modules/.cache && chmod -R 777 node_modules/.cache

# With the volume instruction, the folder /app/node_modules becomes a volume on the host system.
# That allow us to mount it again in compose
# We need to do that because otherwise mounting the app folder unables us to use the node_modules
# folder, because it is installed on the same folder in the container
VOLUME node_modules

# Run the application as a non-root user.
USER node


FROM node:16-alpine
ENV NODE_ENV=production
WORKDIR /app

# Copy all files (including server)
COPY --from=builder /app/node_modules ./node_modules

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD npm start
