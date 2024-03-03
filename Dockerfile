# Use the same base image as your dev container
FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

# Install Node.js (replace "14.x" with your desired version)
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Copy your application code to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Install Ruby and Node.js dependencies
RUN bundle install
RUN npm install

# Build your Vue.js application
RUN npm run build

# Command to run your Roda application
RUN puma config.ru
