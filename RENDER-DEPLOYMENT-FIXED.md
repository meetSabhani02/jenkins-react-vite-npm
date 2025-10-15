# 🚀 Render Deployment Guide - CRITICAL: Persistent Disk Required!

## ⚠️ IMPORTANT: Jenkins REQUIRES a Persistent Disk on Render

### Why Persistent Disk is Required:

- Jenkins needs to create `/var/jenkins_home/jobs/.../builds` directories
- Without persistent disk, Jenkins crashes with: `SEVERE jenkins.model.InvalidBuildsDir`
- Render's ephemeral storage doesn't have proper permissions for Jenkins

## 🔧 Step 1: Create Persistent Disk FIRST

### In Render Dashboard:

1. **Go to your Web Service** → **Disks tab**
2. **Click "Add Disk"**:
   - **Name**: `jenkins-home`
   - **Size**: `10GB` (minimum) or `25GB` (recommended)
   - **Mount Path**: `/var/jenkins_home`
3. **Save** and **Deploy**

### ⚠️ Critical: Do this BEFORE first deployment!

## 🏗️ Step 2: Deploy with Fixed Dockerfile

### Deployment Settings:

- **Service Type**: Web Service
- **Repository**: https://github.com/meetSabhani02/jenkins-react-vite-npm
- **Build Command**: (Leave empty - uses Dockerfile)
- **Start Command**: (Leave empty - uses Dockerfile)
- **Port**: 8080 (auto-detected)

### Environment Variables (Optional):

```
JAVA_OPTS=-Djenkins.install.runSetupWizard=false
```

## ✅ What's Fixed in Dockerfile:

### Permission Fix Added:

```dockerfile
# Ensure the Jenkins home directory exists and is owned by the jenkins user
# This is CRITICAL for Render persistent disk compatibility
RUN mkdir -p /var/jenkins_home && chown -R jenkins:jenkins /var/jenkins_home
```

### Complete Setup Includes:

- ✅ Jenkins LTS with JDK 17
- ✅ Node.js 20 + npm + pnpm
- ✅ Required Jenkins plugins
- ✅ Build tools (zip, git, curl)
- ✅ **Proper /var/jenkins_home permissions**
- ✅ Ports 8080 and 50000

## 🎯 Expected Deployment Process:

### Phase 1: Build (3-5 minutes)

```
✅ Dockerfile build starts
✅ Jenkins plugins downloaded
✅ Node.js 20 installed
✅ Permissions set for /var/jenkins_home
✅ Build complete
```

### Phase 2: Startup (2-3 minutes)

```
✅ Persistent disk mounted to /var/jenkins_home
✅ Jenkins starts with proper permissions
✅ Creates job directories successfully
✅ "Jenkins is fully up and running"
```

## 🚨 Troubleshooting Disk Issues

### If You See These Errors:

```
SEVERE jenkins.model.InvalidBuildsDir: ${ITEM_ROOTDIR}/builds does not exist
Failed to initialize Jenkins
```

**Solution:**

1. ✅ **Add persistent disk** (10GB+) at `/var/jenkins_home`
2. ✅ **Redeploy** with the fixed Dockerfile
3. ✅ **Wait 5-8 minutes** for full startup

### Disk Configuration Check:

- **Mount Path**: Must be exactly `/var/jenkins_home`
- **Size**: Minimum 10GB (25GB recommended)
- **Permissions**: Handled by Dockerfile

## 📊 Total Setup Time:

- **With Persistent Disk**: 5-8 minutes total
- **Without Disk**: ❌ Will crash during startup

## 🎉 After Successful Deployment:

1. **Access Jenkins**: https://jenkins-react-vite-npm.onrender.com/
2. **First Time**: Setup wizard or pre-configured
3. **Create Pipeline Job** with your GitHub repository
4. **Setup GitHub Webhook**
5. **Start Building!**

## 💾 Persistent Disk Benefits:

- ✅ **Build History Preserved** across deployments
- ✅ **Job Configurations Saved**
- ✅ **Plugin Settings Persist**
- ✅ **Workspace Data Retained**
- ✅ **No More Crashes!**

---

**REMEMBER: Persistent Disk is MANDATORY for Jenkins on Render!** 🔥
