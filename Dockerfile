# Dockerfile (use official Jenkins image)
FROM jenkins/jenkins:lts-jdk17

# Skip setup wizard if you want to preconfigure (optional)
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

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

# Ensure the Jenkins home directory exists and is owned by the jenkins user
# This is CRITICAL for Render persistent disk compatibility
RUN mkdir -p /var/jenkins_home && chown -R jenkins:jenkins /var/jenkins_home

# Switch back to jenkins user
USER jenkins

# Copy Jenkins configuration files (optional pre-configuration)
COPY jenkins-config/ /var/jenkins_home/

EXPOSE 8080 50000
