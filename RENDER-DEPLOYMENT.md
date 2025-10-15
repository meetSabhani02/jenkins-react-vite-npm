# 🚀 Render Deployment Guide

## Simple Deployment (Recommended)

### Step 1: Deploy to Render

1. **Connect GitHub Repository**: https://github.com/meetSabhani02/jenkins-react-vite-npm
2. **Service Type**: Web Service
3. **Build Command**: (Leave empty - uses Dockerfile)
4. **Start Command**: (Leave empty - uses Dockerfile)

### Step 2: Environment Variables (Optional)

Add **only if you want to skip Jenkins setup wizard**:

```
Key: JAVA_OPTS
Value: -Djenkins.install.runSetupWizard=false
```

### Step 3: Deploy Settings

- **Port**: 8080 (auto-detected from Dockerfile)
- **Health Check Path**: `/login` (optional)
- **Instance Type**: 512MB (your current plan)

## ✅ What's Already Configured in Dockerfile:

- ✅ Jenkins LTS with JDK 17
- ✅ Node.js 20 + npm + pnpm
- ✅ Required Jenkins plugins
- ✅ Build tools (zip, git, curl)
- ✅ Jenkins configuration files
- ✅ Ports 8080 and 50000

## 🎯 After Deployment:

1. **Access Jenkins**: https://your-app.onrender.com (wait 2-3 minutes)
2. **First Time Setup**:
   - Option A: Follow setup wizard
   - Option B: If JAVA_OPTS set, Jenkins starts pre-configured
3. **Create Pipeline Job** with your GitHub repository
4. **Setup GitHub Webhook**

## 🛠️ No Additional Environment Variables Needed!

The `jenkins.env` file is just for reference. Everything is built into the Docker container.

## 📊 Expected Startup:

- **Build Time**: 3-5 minutes (installing dependencies)
- **Startup Time**: 2-3 minutes (Jenkins initialization)
- **Total Time**: ~5-8 minutes from deploy to ready

## 🎉 Ready to Deploy!

Just push to GitHub and deploy on Render - no complex environment configuration needed!
