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
git commit -m "Add complete Jenkins CI/CD configuration

- Add Jenkinsfile with complete pipeline
- Add Dockerfile with Jenkins and Node.js setup  
- Add plugins.txt with required Jenkins plugins
- Add build.sh with enhanced build process
- Add GitHub webhook setup instructions
- Add comprehensive documentation
- Add deployment checklist and test scripts
- Configure for repository: meetSabhani02/jenkins-react-vite-npm
- Configure for Jenkins URL: https://jenkins-react-vite-npm.onrender.com/"

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