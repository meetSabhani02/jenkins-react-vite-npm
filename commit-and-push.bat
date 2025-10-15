@echo off
echo 🚀 Committing Jenkins CI/CD Configuration
echo ==========================================
echo.

echo 📋 Repository: https://github.com/meetSabhani02/jenkins-react-vite-npm
echo 🏷️  Branch: main
echo.

echo 📦 Adding all Jenkins configuration files...
git add .

echo 📝 Committing changes...
git commit -m "CRITICAL FIX: Jenkins InvalidBuildsDir error + persistent disk support

- Fix Dockerfile: Add proper /var/jenkins_home permissions (jenkins:jenkins)
- Add RENDER-DEPLOYMENT-FIXED.md with persistent disk requirements
- Add CRITICAL-FIX.md with step-by-step solution
- Update troubleshooting documentation
- MANDATORY: Persistent disk (10GB+) must be added in Render at /var/jenkins_home
- This fixes: SEVERE jenkins.model.InvalidBuildsDir crashes
- Jenkins will now start successfully on Render"

echo 🚀 Pushing to GitHub...
git push origin main

echo.
echo ✅ Jenkins configuration pushed to GitHub!
echo.
echo 🎯 Next Steps:
echo 1. Redeploy on Render to pick up new Dockerfile
echo 2. Access Jenkins at: https://jenkins-react-vite-npm.onrender.com
echo 3. Create pipeline job with your GitHub repository
echo 4. Setup webhook at: https://github.com/meetSabhani02/jenkins-react-vite-npm/settings/hooks
echo 5. Test by pushing another change
echo.
echo 📚 Documentation:
echo - GITHUB-JENKINS-SETUP.md (Quick setup guide)
echo - JENKINS-SETUP.md (Detailed documentation)
echo.
echo 🎉 Happy building!