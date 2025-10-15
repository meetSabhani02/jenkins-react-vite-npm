#!/bin/bash

# Jenkins URL Test and Setup Verification
# Tests your Jenkins at: https://jenkins-react-vite-npm.onrender.com/

JENKINS_URL="https://jenkins-react-vite-npm.onrender.com"
GITHUB_REPO="https://github.com/meetSabhani02/jenkins-react-vite-npm"

echo "🔍 Testing Jenkins Setup"
echo "========================"
echo "Jenkins URL: $JENKINS_URL"
echo "GitHub Repo: $GITHUB_REPO"
echo ""

# Test 1: Check if Jenkins is responding
echo "1. Testing Jenkins accessibility..."
if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL/login" | grep -q "200\|403"; then
    echo "   ✅ Jenkins is responding"
else
    echo "   ❌ Jenkins is not accessible"
    echo "   💡 Make sure you've deployed the updated Dockerfile to Render"
fi

# Test 2: Check for Jenkins API
echo ""
echo "2. Testing Jenkins API..."
if curl -s "$JENKINS_URL/api/json" | grep -q "jenkins\|mode"; then
    echo "   ✅ Jenkins API is working"
else
    echo "   ⚠️  Jenkins API not responding (might still be starting up)"
fi

# Test 3: Check for GitHub webhook endpoint
echo ""
echo "3. Testing GitHub webhook endpoint..."
if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL/github-webhook/" | grep -q "200\|405\|403"; then
    echo "   ✅ GitHub webhook endpoint is available"
else
    echo "   ⚠️  GitHub webhook endpoint not responding"
fi

echo ""
echo "📋 Setup Checklist"
echo "=================="

# Check local files
echo "Local Configuration:"
FILES=("Jenkinsfile" "Dockerfile" "plugins.txt" "build.sh")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file exists"
    else
        echo "   ❌ $file missing"
    fi
done

echo ""
echo "🚀 Next Steps:"
echo "=============="
echo "1. If Jenkins is not accessible:"
echo "   → Commit and push all changes to GitHub"
echo "   → Redeploy on Render with the new Dockerfile"
echo "   → Wait 5-8 minutes for startup"
echo ""
echo "2. If Jenkins is accessible:"
echo "   → Go to: $JENKINS_URL"
echo "   → Create new Pipeline job"
echo "   → Configure with GitHub repo: $GITHUB_REPO"
echo "   → Set up webhook at: $GITHUB_REPO/settings/hooks"
echo ""
echo "3. Webhook Configuration:"
echo "   → Payload URL: $JENKINS_URL/github-webhook/"
echo "   → Content type: application/json"
echo "   → Events: Push events"
echo ""
echo "4. Test the pipeline:"
echo "   → Make a small change to your code"
echo "   → Push to main branch"
echo "   → Watch Jenkins trigger automatically"
echo ""
echo "📞 Need help? Check:"
echo "   - GITHUB-JENKINS-SETUP.md"
echo "   - RENDER-DEPLOYMENT.md"
echo "🌐 Jenkins URL: $JENKINS_URL"
echo ""

echo "🔄 Testing Jenkins accessibility..."

# Test if Jenkins is responding
if curl -s -I "$JENKINS_URL" | grep -q "HTTP.*200\|HTTP.*403\|HTTP.*302"; then
    echo "✅ Jenkins is responding!"
    echo "   Status: $(curl -s -I "$JENKINS_URL" | head -n1)"
else
    echo "❌ Jenkins is not responding or still starting up"
    echo "   This is normal if you just deployed - wait 2-3 minutes"
fi

echo ""
echo "🔗 Quick Access Links:"
echo "======================="
echo "🏠 Jenkins Home: $JENKINS_URL"
echo "🔐 Jenkins Login: $JENKINS_URL/login"
echo "⚙️  Jenkins Manage: $JENKINS_URL/manage"
echo "📊 System Info: $JENKINS_URL/systemInfo"
echo ""
echo "🪝 GitHub Webhook Setup:"
echo "========================"
echo "1. Go to: https://github.com/meetSabhani02/jenkins-react-vite-npm/settings/hooks"
echo "2. Add webhook: $JENKINS_URL/github-webhook/"
echo "3. Content type: application/json"
echo "4. Events: Push events"
echo ""
echo "🎯 Pipeline Creation:"
echo "===================="
echo "1. Access: $JENKINS_URL"
echo "2. New Item → Pipeline"
echo "3. Name: jenkins-react-vite-npm-pipeline"
echo "4. Repository: https://github.com/meetSabhani02/jenkins-react-vite-npm.git"
echo "5. Branch: */main"
echo "6. Script path: Jenkinsfile"
echo ""
echo "🚀 After Setup:"
echo "==============="
echo "Push any change to main branch and watch Jenkins automatically build!"
echo "Build artifacts will be available as downloadable ZIP files."
echo ""
echo "📞 Having issues? Check:"
echo "- Render deployment logs"
echo "- Wait 2-3 minutes after deployment"
echo "- Verify GitHub webhook delivery"