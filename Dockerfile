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

# Create essential subdirectories with proper ownership to prevent startup failures
RUN mkdir -p /var/jenkins_home/jobs \
  /var/jenkins_home/workspace \
  /var/jenkins_home/logs \
  /var/jenkins_home/plugins \
  && chown -R jenkins:jenkins /var/jenkins_home

# Switch back to jenkins user
USER jenkins

# Copy Jenkins configuration files (optional pre-configuration)
COPY jenkins-config/ /var/jenkins_home/

EXPOSE 8080 50000

# Add comprehensive health check for Render deployment monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/login || exit 1

# Add startup script to handle disk mounting timing and permission issues
USER root
RUN echo '#!/bin/bash\n\
  # Wait for disk mount and fix permissions if needed\n\
  while [ ! -d "/var/jenkins_home" ]; do\n\
  echo "Waiting for /var/jenkins_home to be available..."\n\
  sleep 2\n\
  done\n\
  \n\
  # Ensure proper ownership of jenkins home and subdirectories\n\
  chown -R jenkins:jenkins /var/jenkins_home\n\
  \n\
  # Create essential directories if missing\n\
  mkdir -p /var/jenkins_home/jobs /var/jenkins_home/workspace /var/jenkins_home/logs\n\
  chown -R jenkins:jenkins /var/jenkins_home\n\
  \n\
  # Switch to jenkins user and start Jenkins\n\
  exec gosu jenkins /usr/local/bin/jenkins.sh "$@"\n\
  ' > /usr/local/bin/startup.sh && chmod +x /usr/local/bin/startup.sh

# Install gosu for proper user switching
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

USER jenkins

# Use startup script as entrypoint to handle disk mounting timing
ENTRYPOINT ["/usr/local/bin/startup.sh"]
