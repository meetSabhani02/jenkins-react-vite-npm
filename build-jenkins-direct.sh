#!/bin/bash

# Simple build script that creates accessible artifacts in Jenkins
# No external storage needed - artifacts served directly from Jenkins!

set -e

echo "🚀 Starting React Vite Build with Direct Jenkins Artifact Access"
echo "================================================================"

# Get version from package.json
VERSION=$(node -p "require('./package.json').version")
BUILD_TIME=$(date +"%Y%m%d_%H%M%S")
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_ID="${BUILD_NUMBER:-local}-${BUILD_TIME}"

echo "📦 Project: jenkins-react-vite-npm"
echo "🏷️  Version: $VERSION"
echo "🆔 Build ID: $BUILD_ID"
echo "🕒 Build Time: $BUILD_TIME"
echo "📝 Commit: $COMMIT_HASH"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/
rm -rf artifacts/
mkdir -p artifacts

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Run linting
echo "🔍 Running ESLint..."
npm run lint

# Build the project
echo "🏗️  Building React Vite project..."
npm run build

# Verify build output
if [ ! -d "dist" ]; then
    echo "❌ Build failed - no dist directory found"
    exit 1
fi

echo "✅ Build completed successfully!"
echo ""

# Create artifacts with Jenkins-accessible URLs
echo "📋 Creating Jenkins-accessible artifacts..."
ARTIFACT_NAME="jenkins-react-vite-npm-v${VERSION}-build-${BUILD_ID}"

cd dist
zip -r "../artifacts/${ARTIFACT_NAME}.zip" .
cd ..

# Create source backup
zip -r "artifacts/${ARTIFACT_NAME}-source.zip" . \
    -x "node_modules/*" \
    -x ".git/*" \
    -x "dist/*" \
    -x "artifacts/*" \
    -x "*.log"

# Create build info with Jenkins URLs
JENKINS_BASE_URL="${JENKINS_URL:-https://your-jenkins.onrender.com}"
JOB_NAME="${JOB_NAME:-jenkins-react-vite-npm-pipeline}"
BUILD_NUM="${BUILD_NUMBER:-local}"

cat > artifacts/build-info.json << EOF
{
  "buildId": "${BUILD_ID}",
  "version": "${VERSION}",
  "buildTime": "${BUILD_TIME}",
  "commitHash": "${COMMIT_HASH}",
  "jenkinsBuildNumber": "${BUILD_NUM}",
  "artifactName": "${ARTIFACT_NAME}.zip",
  "downloadUrls": {
    "buildZip": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/${ARTIFACT_NAME}.zip",
    "sourceZip": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/${ARTIFACT_NAME}-source.zip",
    "buildInfo": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/build-info.json",
    "consoleOutput": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/console"
  },
  "jenkinsUrls": {
    "buildPage": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/",
    "artifacts": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/",
    "console": "${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/console"
  },
  "status": "success",
  "nodeVersion": "$(node --version)",
  "npmVersion": "$(npm --version)"
}
EOF

# Create a simple HTML index for artifacts
cat > artifacts/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Build ${BUILD_ID} - jenkins-react-vite-npm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .success { color: #28a745; }
        .info { background: #f0f8ff; padding: 20px; border-radius: 5px; margin: 20px 0; }
        .download-btn { background: #007bff; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 10px 0; }
        .download-btn:hover { background: #0056b3; }
        .build-id { font-family: monospace; background: #f8f9fa; padding: 5px 10px; border-radius: 3px; }
        .jenkins-link { color: #dc3545; text-decoration: none; }
        .jenkins-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="success">✅ Build ${BUILD_ID} Successful!</h1>
        
        <div class="info">
            <h2>Build Information</h2>
            <p><strong>Build ID:</strong> <span class="build-id">${BUILD_ID}</span></p>
            <p><strong>Jenkins Build:</strong> <a href="${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/" class="jenkins-link">#${BUILD_NUM}</a></p>
            <p><strong>Version:</strong> ${VERSION}</p>
            <p><strong>Build Time:</strong> ${BUILD_TIME}</p>
            <p><strong>Commit:</strong> ${COMMIT_HASH}</p>
        </div>

        <h2>📥 Download Build Artifacts</h2>
        <a href="${ARTIFACT_NAME}.zip" class="download-btn">📦 Download Main Build ZIP</a>
        <a href="${ARTIFACT_NAME}-source.zip" class="download-btn">📋 Download Source Backup</a>

        <h2>🔗 Jenkins Links</h2>
        <ul>
            <li><a href="${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/" class="jenkins-link">📊 Build Page</a></li>
            <li><a href="${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/console" class="jenkins-link">📝 Console Output</a></li>
            <li><a href="${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/" class="jenkins-link">📁 All Artifacts</a></li>
        </ul>

        <h2>🔗 Direct Download URLs</h2>
        <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; font-family: monospace; font-size: 12px; overflow-wrap: break-word;">
            <p><strong>Main ZIP:</strong><br>
            ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/${ARTIFACT_NAME}.zip</p>
            
            <p><strong>Source ZIP:</strong><br>
            ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/${ARTIFACT_NAME}-source.zip</p>
            
            <p><strong>Build Info:</strong><br>
            ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/build-info.json</p>
        </div>

        <h2>📋 Build Contents</h2>
        <pre>$(ls -la dist/ | head -20)</pre>

        <h2>🚀 Usage</h2>
        <ol>
            <li>Click "Download Main Build ZIP" above</li>
            <li>Extract to your web server</li>
            <li>Configure for SPA routing if needed</li>
            <li>Your React app is ready!</li>
        </ol>
        
        <p><em>All files are served directly from Jenkins - no external storage needed!</em></p>
    </div>
</body>
</html>
EOF

echo "📊 Artifact Summary:"
echo "==================="
ls -la artifacts/
echo ""

echo "🎉 Build process completed successfully!"
echo "📦 Main artifact: ${ARTIFACT_NAME}.zip"
echo "🆔 Build ID: ${BUILD_ID}"
echo ""
echo "🌐 Jenkins URLs (available after archiving):"
echo "  📥 Main ZIP: ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/${ARTIFACT_NAME}.zip"
echo "  📋 Build Info: ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/build-info.json"
echo "  📄 Build Page: ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/artifact/artifacts/index.html"
echo "  📊 Jenkins Build: ${JENKINS_BASE_URL}/job/${JOB_NAME}/${BUILD_NUM}/"
echo ""
echo "🚀 No external storage needed - everything served from Jenkins!"