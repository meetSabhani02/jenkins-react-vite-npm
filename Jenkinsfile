pipeline {
    agent any
    
    environment {
        // Define environment variables
        NODE_VERSION = '20'
        BUILD_DIR = 'dist'
        ARTIFACT_NAME = "${env.JOB_NAME}-${env.BUILD_NUMBER}"
        PATH = "/usr/bin:$PATH"
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
                sh '''
                    node --version
                    npm --version
                    npm ci
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