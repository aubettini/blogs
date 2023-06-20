# Use the official lightweight Node.js 14 image.
# https://hub.docker.com/_/node
# FROM node:14-slim
FROM --platform=linux/amd64 node:lts-alpine

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Copy local code to the container image.
COPY . .

# Expose the application on port 8080
EXPOSE 8080

# Run the web service on container startup.
CMD [ "node", "server.js" ]
