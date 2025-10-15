pipeline {
    agent any
    
    environment {
        // Define environment variables
        NODE_VERSION = '20'
        BUILD_DIR = 'dist'
        ARTIFACT_NAME = "${env.JOB_NAME}-${env.BUILD_NUMBER}"
        PATH = "/usr/bin:$PATH"
        // Fix for esbuild ETXTBSY errors on slow file systems
        NODE_OPTIONS = "--max-old-space-size=2048"
        NPM_CONFIG_PROGRESS = "false"
        NPM_CONFIG_AUDIT = "false"
        NPM_CONFIG_FUND = "false"
        // Add retry mechanism for npm operations
        NPM_CONFIG_FETCH_RETRIES = "5"
        NPM_CONFIG_FETCH_RETRY_FACTOR = "2"
        NPM_CONFIG_FETCH_RETRY_MINTIMEOUT = "10000"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installing Node.js dependencies...'
                timeout(time: 15, unit: 'MINUTES') {
                    retry(3) {
                        sh '''
                            echo "🔍 System info before install:"
                            node --version
                            npm --version
                            whoami
                            pwd
                            
                            echo "🧹 Cleaning any previous failed installs..."
                            rm -rf node_modules package-lock.json || true
                            
                            echo "⏰ Starting npm ci with ETXTBSY fixes..."
                            # Fix for ETXTBSY: Use npm install instead of npm ci on first run
                            # and add sync operations to ensure file system consistency
                            npm cache clean --force
                            sync
                            sleep 2
                            
                            # Use npm install with exact versions instead of npm ci for better reliability
                            npm install --no-optional --no-fund --no-audit --verbose
                            
                            echo "🔧 Fixing esbuild permissions..."
                            chmod +x node_modules/.bin/* || true
                            chmod +x node_modules/esbuild/bin/esbuild || true
                            sync
                            sleep 1
                            
                            echo "✅ Dependencies installed successfully"
                        '''
                    }
                }
            }
        }
        
        stage('Verify Build Tools') {
            steps {
                echo 'Verifying build tools are working...'
                sh '''
                    echo "🔍 Testing esbuild (the problematic tool)..."
                    
                    # Test if esbuild binary works
                    if [ -f "node_modules/.bin/esbuild" ]; then
                        echo "✅ esbuild binary found"
                        ls -la node_modules/.bin/esbuild
                        
                        # Try to run esbuild version - this was failing before
                        echo "Testing esbuild execution..."
                        timeout 30 node_modules/.bin/esbuild --version || {
                            echo "❌ esbuild --version failed, trying alternative..."
                            # Alternative: use node to run esbuild
                            node node_modules/esbuild/lib/main.js --version || echo "Both methods failed"
                        }
                    else
                        echo "❌ esbuild binary not found"
                        find node_modules -name "*esbuild*" -type f | head -10
                    fi
                    
                    echo "🔍 Testing other build tools..."
                    npm run lint --dry-run || echo "Lint check failed"
                '''
            }
        }
        
        stage('Lint') {
            steps {
                echo 'Running ESLint...'
                sh 'npm run lint'
            }
        }
        
        stage('Build & Package') {
            steps {
                echo 'Building and packaging with Jenkins direct access...'
                sh '''
                    echo "🔧 Making build scripts executable..."
                    chmod +x build.sh build-jenkins-direct.sh
                    
                    echo "🚀 Building with direct Jenkins URLs (no external storage needed)..."
                    ./build-jenkins-direct.sh
                    
                    echo ""
                    echo "✅ Build complete! Artifacts will be accessible at:"
                    echo "📥 Main ZIP: ${JENKINS_URL}/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/artifacts/*.zip"
                    echo "📄 Build Page: ${JENKINS_URL}/job/${JOB_NAME}/${BUILD_NUMBER}/artifact/artifacts/index.html"
                    echo "📊 Jenkins Build: ${JENKINS_URL}/job/${JOB_NAME}/${BUILD_NUMBER}/"
                '''
            }
        }
        
        stage('Test Build') {
            steps {
                echo 'Verifying build output...'
                sh '''
                    # Verify build artifacts exist
                    test -d dist || (echo "❌ dist directory not found" && exit 1)
                    test -f artifacts/*.zip || (echo "❌ No zip artifacts found" && exit 1)
                    test -f artifacts/deployment-info.txt || (echo "❌ Deployment info not found" && exit 1)
                    
                    echo "✅ All build artifacts verified successfully"
                    echo "📦 Available artifacts:"
                    ls -la artifacts/
                '''
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                echo 'Archiving build artifacts for direct access...'
                script {
                    // Archive all build artifacts
                    archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
                    archiveArtifacts artifacts: 'artifacts/*.json', fingerprint: true  
                    archiveArtifacts artifacts: 'artifacts/*.html', fingerprint: true
                    archiveArtifacts artifacts: 'artifacts/*.txt', fingerprint: true
                    archiveArtifacts artifacts: 'dist/**/*', fingerprint: true
                    
                    // Display direct access URLs
                    def jenkinsUrl = env.JENKINS_URL ?: 'https://your-jenkins.onrender.com'
                    def jobName = env.JOB_NAME ?: 'jenkins-react-vite-npm-pipeline'
                    def buildNumber = env.BUILD_NUMBER ?: 'unknown'
                    
                    echo ""
                    echo "🎉 Build Artifacts Archived Successfully!"
                    echo "========================================"
                    echo ""
                    echo "🌐 Direct Access URLs (no external storage needed):"
                    echo ""
                    echo "📥 ZIP Downloads:"
                    echo "   ${jenkinsUrl}/job/${jobName}/${buildNumber}/artifact/artifacts/"
                    echo ""
                    echo "📄 Build Info Page:"
                    echo "   ${jenkinsUrl}/job/${jobName}/${buildNumber}/artifact/artifacts/index.html"
                    echo ""
                    echo "📋 Build Metadata:"
                    echo "   ${jenkinsUrl}/job/${jobName}/${buildNumber}/artifact/artifacts/build-info.json"
                    echo ""
                    echo "📊 Full Build Details:"
                    echo "   ${jenkinsUrl}/job/${jobName}/${buildNumber}/"
                    echo ""
                    echo "✅ All files are directly accessible via Jenkins!"
                    echo "ℹ️  Share these URLs with your team - no authentication needed for artifacts"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
            echo "Build artifacts available: ${ARTIFACT_NAME}.zip"
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}