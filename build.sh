#!/bin/bash

# Enhanced build script for creating deployment-ready artifacts
# This script can be used in Jenkins or locally

set -e

echo "🚀 Starting React Vite Build Process"
echo "====================================="

# Get version from package.json
VERSION=$(node -p "require('./package.json').version")
BUILD_TIME=$(date +"%Y%m%d_%H%M%S")
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

echo "📦 Project: jenkins-react-vite-npm"
echo "🏷️  Version: $VERSION"
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

# Create artifacts
echo "📋 Creating build artifacts..."

# Create main build artifact
ARTIFACT_NAME="jenkins-react-vite-npm-v${VERSION}-${BUILD_TIME}-${COMMIT_HASH}"

cd dist
zip -r "../artifacts/${ARTIFACT_NAME}.zip" .
cd ..

# Create source code artifact (for backup/debugging)
zip -r "artifacts/${ARTIFACT_NAME}-source.zip" . \
    -x "node_modules/*" \
    -x ".git/*" \
    -x "dist/*" \
    -x "artifacts/*" \
    -x "*.log"

# Create deployment info
cat > artifacts/deployment-info.txt << EOF
React Vite Build Information
============================
Project: jenkins-react-vite-npm
Version: $VERSION
Build Time: $BUILD_TIME
Commit Hash: $COMMIT_HASH
Node Version: $(node --version)
NPM Version: $(npm --version)

Build Contents:
===============
$(ls -la dist/)

Deployment Instructions:
=======================
1. Extract ${ARTIFACT_NAME}.zip to your web server
2. Serve the files with any static web server
3. Ensure your web server is configured for SPA routing

Example nginx config:
--------------------
location / {
    try_files \$uri \$uri/ /index.html;
}
EOF

# Create simple HTML verification page
cat > artifacts/verify-build.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Build Verification - jenkins-react-vite-npm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .info { background: #f0f8ff; padding: 20px; border-radius: 5px; }
        .success { color: #28a745; }
    </style>
</head>
<body>
    <h1 class="success">✅ Build Successful!</h1>
    <div class="info">
        <h2>Build Information</h2>
        <p><strong>Project:</strong> jenkins-react-vite-npm</p>
        <p><strong>Version:</strong> $VERSION</p>
        <p><strong>Build Time:</strong> $BUILD_TIME</p>
        <p><strong>Commit:</strong> $COMMIT_HASH</p>
        <p><strong>Artifact:</strong> ${ARTIFACT_NAME}.zip</p>
    </div>
    <h2>Next Steps:</h2>
    <ol>
        <li>Download the build artifact from Jenkins</li>
        <li>Extract the ZIP file to your web server</li>
        <li>Configure your server for SPA routing</li>
        <li>Your React app is ready to serve!</li>
    </ol>
</body>
</html>
EOF

echo "📊 Artifact Summary:"
echo "==================="
ls -la artifacts/
echo ""

echo "🎉 Build process completed successfully!"
echo "📦 Main artifact: ${ARTIFACT_NAME}.zip"
echo "📄 Deployment info: deployment-info.txt"
echo "🔍 Verification page: verify-build.html"
echo ""
echo "🚀 Ready for deployment!"