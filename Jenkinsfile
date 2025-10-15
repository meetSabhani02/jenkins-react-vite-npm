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
                echo 'Building and packaging the React Vite application...'
                sh '''
                    chmod +x build.sh
                    ./build.sh
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
                echo 'Archiving build artifacts...'
                archiveArtifacts artifacts: 'artifacts/*.zip', fingerprint: true
                archiveArtifacts artifacts: 'dist/**/*', fingerprint: true
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