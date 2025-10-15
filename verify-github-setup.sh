#!/bin/bash

# GitHub Integration Verification Script
# This script helps verify your GitHub repository setup

echo "🔍 GitHub Integration Verification"
echo "=================================="
echo ""

# Repository information
REPO_URL="https://github.com/meetSabhani02/jenkins-react-vite-npm"
JENKINS_URL="https://jenkins-react-vite-npm.onrender.com"

echo "📊 Repository Information:"
echo "  URL: $REPO_URL"
echo "  Owner: meetSabhani02"
echo "  Repository: jenkins-react-vite-npm"
echo "  Branch: main"
echo ""

echo "🔗 Jenkins Information:"
echo "  URL: $JENKINS_URL"
echo "  Pipeline: jenkins-react-vite-npm-pipeline"
echo "  Webhook: $JENKINS_URL/github-webhook/"
echo ""

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✅ Git repository detected"
    
    # Get current branch
    CURRENT_BRANCH=$(git branch --show-current)
    echo "  Current branch: $CURRENT_BRANCH"
    
    # Get remote URL
    REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "No remote configured")
    echo "  Remote URL: $REMOTE_URL"
    
    # Check if remote matches expected
    if [[ "$REMOTE_URL" == *"meetSabhani02/jenkins-react-vite-npm"* ]]; then
        echo "  ✅ Remote URL matches expected repository"
    else
        echo "  ⚠️  Remote URL doesn't match expected repository"
        echo "     Expected: https://github.com/meetSabhani02/jenkins-react-vite-npm.git"
        echo "     Actual: $REMOTE_URL"
    fi
    
    # Get last commit
    LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%cr)" 2>/dev/null || echo "No commits")
    echo "  Last commit: $LAST_COMMIT"
    
else
    echo "❌ Not in a git repository"
fi

echo ""
echo "📋 Setup Checklist:"
echo "==================="

# Check if important files exist
FILES=("Jenkinsfile" "Dockerfile" "plugins.txt" "build.sh" "package.json")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file exists"
    else
        echo "  ❌ $file missing"
    fi
done

echo ""
echo "🚀 Next Steps:"
echo "=============="
echo "1. Commit and push all changes:"
echo "   git add ."
echo "   git commit -m 'Add Jenkins CI/CD configuration'"
echo "   git push origin main"
echo ""
echo "2. Redeploy on Render to pick up new Dockerfile"
echo ""
echo "3. Access Jenkins at: $JENKINS_URL"
echo ""
echo "4. Create pipeline job with repository: $REPO_URL"
echo ""
echo "5. Setup GitHub webhook at:"
echo "   $REPO_URL/settings/hooks"
echo "   Webhook URL: $JENKINS_URL/github-webhook/"
echo ""
echo "6. Test by pushing a change to main branch"
echo ""
echo "🎯 Expected Result:"
echo "   Automatic builds triggered on pushes to main branch"
echo "   Build artifacts available as downloadable ZIP files"
echo ""
echo "📞 For help, check:"
echo "   - GITHUB-JENKINS-SETUP.md (detailed setup guide)"
echo "   - JENKINS-SETUP.md (comprehensive documentation)"