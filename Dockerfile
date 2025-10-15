# Dockerfile (use official Jenkins image)
FROM jenkins/jenkins:lts-jdk17

# Skip setup wizard if you want to preconfigure (optional)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install common tools used by pipelines (zip, node, npm, git)
USER root

# install zip and curl (Debian base)
RUN apt-get update && apt-get install -y zip curl git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install Node (for building Vite)
# Using Node 20.x as example — adjust if you prefer another version
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g pnpm

# Switch back to jenkins user
USER jenkins

# (Optional) copy predefined Jenkins config or plugins bootstrap if you have them
# COPY jenkins/ /var/jenkins_home/  # only if you want seeded config

EXPOSE 8080 50000
