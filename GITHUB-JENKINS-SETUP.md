# 🚀 Jenkins Setup Guide for jenkins-react-vite-npm

## Repository Information

- **GitHub URL**: https://github.com/meetSabhani02/jenkins-react-vite-npm
- **Owner**: meetSabhani02
- **Repository**: jenkins-react-vite-npm
- **Main Branch**: main

## 📋 Quick Setup Checklist

### ✅ 1. Deploy to Render

```bash
# Your files are ready! Just push to GitHub and redeploy on Render
git add .
git commit -m "Add Jenkins CI/CD configuration"
git push origin main
```

### ✅ 2. Access Jenkins (After Render Deployment)

- **Jenkins URL**: https://jenkins-react-vite-npm.onrender.com
- **Wait Time**: 2-3 minutes for first startup
- **Default Ports**: 8080 (HTTP), 50000 (Agent)

### ✅ 3. Create Jenkins Pipeline Job

1. **Access Jenkins UI** → New Item
2. **Enter Name**: `jenkins-react-vite-npm-pipeline`
3. **Select**: Pipeline
4. **Click**: OK

**Pipeline Configuration:**

- **General** → Description: `CI/CD Pipeline for React Vite project`
- **Build Triggers** → ✅ `GitHub hook trigger for GITScm polling`
- **Pipeline** → Definition: `Pipeline script from SCM`
- **SCM**: Git
- **Repository URL**: `https://github.com/meetSabhani02/jenkins-react-vite-npm.git`
- **Credentials**: (Leave empty for public repo)
- **Branch Specifier**: `*/main`
- **Script Path**: `Jenkinsfile`

### ✅ 4. Setup GitHub Webhook

**Go to**: https://github.com/meetSabhani02/jenkins-react-vite-npm/settings/hooks

**Click**: Add webhook

**Configuration**:

```
Payload URL: https://jenkins-react-vite-npm.onrender.com/github-webhook/
Content type: application/json
Secret: (leave empty)
```

**Which events**:

- ✅ Just the push event
- ✅ Pull requests (optional)
- ✅ Active

### ✅ 5. Test Your Setup

**Method 1: Manual Test**

1. Go to Jenkins → jenkins-react-vite-npm-pipeline
2. Click "Build Now"
3. Watch the build progress

**Method 2: Automatic Test**

1. Make a small change in your repository
2. Push to main branch:

```bash
git add .
git commit -m "Test Jenkins CI/CD"
git push origin main
```

3. Check Jenkins for automatic build trigger

## 🎯 Expected Build Process

Your pipeline will automatically:

1. **Checkout** → Downloads code from GitHub
2. **Install Dependencies** → Runs `npm ci`
3. **Lint** → Runs `eslint .`
4. **Build & Package** → Executes `build.sh`
5. **Test Build** → Verifies artifacts
6. **Archive Artifacts** → Saves ZIP files

## 📦 Build Artifacts

After successful builds, download from Jenkins:

- **Main Build**: `jenkins-react-vite-npm-v{version}-{timestamp}-{commit}.zip`
- **Source Code**: `jenkins-react-vite-npm-v{version}-{timestamp}-{commit}-source.zip`
- **Deployment Info**: `deployment-info.txt`
- **Verification**: `verify-build.html`

## 🔗 Important URLs

- **GitHub Repository**: https://github.com/meetSabhani02/jenkins-react-vite-npm
- **Jenkins Dashboard**: https://jenkins-react-vite-npm.onrender.com
- **Pipeline Job**: https://jenkins-react-vite-npm.onrender.com/job/jenkins-react-vite-npm-pipeline/
- **GitHub Webhooks**: https://github.com/meetSabhani02/jenkins-react-vite-npm/settings/hooks

## 🛠️ Troubleshooting

### Jenkins Not Loading?

```bash
# Check Render logs
# Ensure all files are committed and pushed
# Wait 2-3 minutes for startup
```

### Webhook Not Working?

1. Check GitHub webhook deliveries
2. Verify Jenkins URL is accessible
3. Test manual build first

### Build Failing?

1. Check Jenkins console output
2. Verify Node.js dependencies
3. Test build locally: `npm run build`

## 🎉 Success Indicators

✅ Jenkins accessible at your Render URL  
✅ Pipeline job created and configured  
✅ GitHub webhook delivering events  
✅ Builds triggering on push to main  
✅ Build artifacts being created  
✅ ZIP files available for download

## 📞 Next Steps After Setup

1. **Configure Notifications** (Email, Slack)
2. **Add Tests** to the pipeline
3. **Setup Staging/Production** deployments
4. **Monitor Build Performance**
5. **Add Security Scanning**

---

**Repository**: https://github.com/meetSabhani02/jenkins-react-vite-npm  
**Owner**: meetSabhani02  
**Setup Date**: October 15, 2025

🚀 **Happy Building!**
