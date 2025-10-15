# 🔧 Jenkins Troubleshooting Guide

## Common Warnings and Solutions

### ❌ **CRITICAL: InvalidBuildsDir Error (FIXED)**

```
SEVERE jenkins.model.InvalidBuildsDir: ${ITEM_ROOTDIR}/builds does not exist and probably cannot be created
Failed to initialize Jenkins
```

**Cause:** Jenkins cannot create directories in `/var/jenkins_home`
**Solution Applied:**

- ✅ Added persistent disk requirement in RENDER-DEPLOYMENT-FIXED.md
- ✅ Fixed Dockerfile with proper permissions: `chown -R jenkins:jenkins /var/jenkins_home`
- ✅ **You MUST add a persistent disk to Render** (10GB+) mounted at `/var/jenkins_home`

### ✅ **NodeJS Configuration Warning (FIXED)**

```
WARNING hudson.model.Descriptor#load: Failed to load /var/jenkins_home/jenkins.plugins.nodejs.tools.NodeJSInstallation.xml
```

**Solution Applied:**

- ✅ Removed pre-configuration file that was causing conflicts
- ✅ Updated Jenkinsfile to use Node.js directly from Docker container
- ✅ Node.js 20 is pre-installed in the Docker image at `/usr/bin/node`

### ✅ **Global Timeout Warning (Normal)**

```
INFO h.p.b.g.GlobalTimeOutConfiguration#load: global timeout not set
```

**Status:** This is normal - no global timeout is configured (which is fine)

### ✅ **Empty Context Path Warning (Normal)**

```
WARNING o.e.j.ee9.nested.ContextHandler#setContextPath: Empty contextPath
```

**Status:** This is a harmless Jetty web server warning - Jenkins works fine with empty context path

### ✅ **Connection Errors (Normal)**

```
INFO h.TcpSlaveAgentListener$ConnectionHandler#run: Connection #X from /[0:0:0:0:0:0:0:1]:XXXXX failed: null
```

**Status:** These are normal on Render - Jenkins trying to establish slave connections that aren't needed for basic pipelines

## 🎯 Current Configuration Status

### Node.js Setup:

- ✅ Node.js 20 installed in Docker container
- ✅ Available at `/usr/bin/node` and `/usr/bin/npm`
- ✅ Jenkinsfile updated to use system Node.js
- ✅ No pre-configuration conflicts

### Pipeline Configuration:

```groovy
environment {
    NODE_VERSION = '20'
    PATH = "/usr/bin:$PATH"
}
```

### Build Process:

1. ✅ Checkout code from GitHub
2. ✅ Install dependencies with `npm ci`
3. ✅ Run ESLint for code quality
4. ✅ Build with `npm run build`
5. ✅ Create deployment artifacts
6. ✅ Archive ZIP files

## 🚀 Expected Behavior

### Normal Startup Logs:

```
✅ Jenkins starting up
✅ Plugins loading
✅ Global timeout not set (INFO - normal)
✅ Empty contextPath warning (WARNING - harmless)
✅ Node.js available
✅ Ready for builds
```

### Successful Build Logs:

```
✅ Checkout from GitHub
✅ Node.js version: v20.x.x
✅ npm install completed
✅ ESLint passed
✅ Build completed
✅ Artifacts created
```

## 🛠️ If You See Other Warnings

### Plugin Loading Issues:

- Wait for full Jenkins startup (2-3 minutes)
- Check if all plugins from `plugins.txt` are installed
- Restart Jenkins if needed

### Build Failures:

- Check Node.js is available: `node --version`
- Verify dependencies: `npm ci`
- Test locally: `npm run build`

### GitHub Integration Issues:

- Verify webhook URL: `https://jenkins-react-vite-npm.onrender.com/github-webhook/`
- Check GitHub webhook deliveries
- Test manual build first

## ✅ Your Setup is Working!

The NodeJS warning has been resolved. Your Jenkins is properly configured with:

- ✅ Node.js 20 pre-installed
- ✅ All required build tools
- ✅ GitHub integration ready
- ✅ Automated CI/CD pipeline

Just deploy and start building! 🎉
