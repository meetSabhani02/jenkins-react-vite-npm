# Jenkins CI/CD Setup for React Vite Project

This repository contains a complete Jenkins CI/CD setup for a React Vite application hosted on Render.

## 🚀 Features

- **Automated builds** triggered by GitHub pushes to main branch
- **Build artifacts** created as downloadable ZIP files
- **Docker-based Jenkins** with pre-configured plugins
- **Node.js 20** support for Vite builds
- **ESLint integration** for code quality
- **Deployment-ready artifacts** with deployment instructions

## 📁 Project Structure

```
├── Dockerfile              # Jenkins container configuration
├── Jenkinsfile             # Pipeline configuration
├── plugins.txt             # Required Jenkins plugins
├── jenkins-config/         # Jenkins configuration files
├── build.sh               # Enhanced build script
├── setup-webhook.sh       # GitHub webhook setup guide
└── src/                   # React application source
```

## 🔧 Setup Instructions

### 1. Deploy to Render

1. Connect your GitHub repository to Render
2. Deploy as a **Web Service**
3. Use the provided `Dockerfile`
4. Set environment variables if needed

### 2. Access Jenkins

Once deployed, Jenkins will be available at:

```
https://jenkins-react-vite-npm.onrender.com
```

### 3. Initial Jenkins Setup

1. **First-time access**: Use the setup wizard (or skip if configured)
2. **Install plugins**: Already pre-configured in `plugins.txt`
3. **Create admin user**: Set up your admin credentials
4. **Configure tools**: Node.js is pre-configured as "NodeJS-20"

### 4. Create Pipeline Job

1. **New Item** → **Pipeline**
2. **Name**: `jenkins-react-vite-npm-pipeline`
3. **Pipeline Configuration**:
   - **Definition**: Pipeline script from SCM
   - **SCM**: Git
   - **Repository URL**: `https://github.com/meetSabhani02/jenkins-react-vite-npm.git`
   - **Branch**: `*/main`
   - **Script Path**: `Jenkinsfile`

### 5. Configure GitHub Webhook

Run the setup script for detailed instructions:

```bash
./setup-webhook.sh
```

Or manually configure:

1. Go to GitHub repository → **Settings** → **Webhooks**
2. **Add webhook**:
   - **Payload URL**: `https://jenkins-react-vite-npm.onrender.com/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: Push events, Pull requests
   - **Active**: ✅

### 6. Enable Build Triggers

In your Jenkins job configuration:

1. **Build Triggers** → ✅ **GitHub hook trigger for GITScm polling**
2. **Build Triggers** → ✅ **Poll SCM** (leave schedule empty)

## 🏗️ Build Process

The pipeline includes these stages:

1. **Checkout** - Gets latest code from GitHub
2. **Install Dependencies** - Runs `npm ci`
3. **Lint** - Runs ESLint for code quality
4. **Build & Package** - Builds app and creates artifacts
5. **Test Build** - Verifies build artifacts
6. **Archive Artifacts** - Saves artifacts in Jenkins

## 📦 Build Artifacts

After each successful build, you'll get:

- **Main artifact**: `jenkins-react-vite-npm-v{version}-{timestamp}-{commit}.zip`
- **Source backup**: `*-source.zip`
- **Deployment info**: `deployment-info.txt`
- **Verification page**: `verify-build.html`

## 🎯 Trigger Builds

Builds are automatically triggered when:

- Code is pushed to `main` branch
- Pull requests are merged to `main`
- Manual trigger from Jenkins UI

## 📊 Monitoring

### Jenkins Logs

Monitor build status in Jenkins UI at:

```
https://jenkins-react-vite-npm.onrender.com/job/jenkins-react-vite-npm-pipeline/
```

### Render Logs

Check container logs in Render dashboard for:

- Jenkins startup issues
- Container health
- Resource usage

## 🛠️ Troubleshooting

### Common Issues

1. **"Connection failed" errors**: These are normal for Jenkins slave agent connections on Render
2. **Build failures**: Check Node.js version compatibility
3. **Webhook not working**: Verify GitHub webhook URL and Jenkins accessibility

### Debug Commands

```bash
# Check Jenkins logs
docker logs <container-id>

# Verify build locally
npm ci
npm run build

# Test build script
chmod +x build.sh
./build.sh
```

## 🔧 Configuration Files

### Dockerfile

- Base: `jenkins/jenkins:lts-jdk17`
- Pre-installs: Node.js 20, npm, pnpm, zip, git
- Skips setup wizard
- Loads plugins and configurations

### Jenkinsfile

- Multi-stage pipeline
- Node.js tool integration
- Artifact creation and archiving
- Error handling and cleanup

### plugins.txt

Essential Jenkins plugins:

- GitHub integration
- Node.js tools
- Blue Ocean UI
- Pipeline plugins
- Webhook triggers

## 🚀 Deployment

Build artifacts are ready for deployment to any static hosting service:

1. Download the ZIP artifact from Jenkins
2. Extract to your web server
3. Configure for SPA routing (if needed)
4. Your React app is live!

Example nginx configuration:

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

## 📈 Next Steps

- Add unit tests to the pipeline
- Set up staging/production environments
- Implement deployment automation
- Add notification integrations (Slack, email)
- Monitor performance metrics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Push to main branch
5. Jenkins will automatically build and test your changes!

## 📞 Support

For issues or questions:

- Check Jenkins build logs
- Review Render container logs
- Verify GitHub webhook configuration
- Test build process locally

---

**Happy Building! 🎉**
