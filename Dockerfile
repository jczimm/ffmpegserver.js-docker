# syntax=docker/dockerfile:1

FROM node:22-alpine

WORKDIR /usr/src/app

ENV NODE_ENV=development

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.npm to speed up subsequent builds.
# However, do NOT leverage bind mounts to package.json and package-lock.json, since can result in read-only-filesystem error.
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm install

# Run the application as a non-root user for security.
USER node

# Copy the rest of the source files into the image.
COPY . .

# Expose the port that the application listens on.
EXPOSE 8080

# Run the application.
RUN mkdir /home/node/output
CMD ["node", "start.js", "--allow-arbitrary-ffmpeg-arguments", "--video-dir=/home/node/output", "--frame-dir=/home/node/output"]
