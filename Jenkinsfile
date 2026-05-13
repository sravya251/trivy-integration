pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        IMAGE_NAME = "myapp"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'master',
                url: 'https://github.com/sravya251/trivy-integration.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Verify Image') {
            steps {
                sh "docker images"
            }
        }

       stage('Trivy Scan') {
    steps {
        sh '''
        export TRIVY_CACHE_DIR=/tmp/trivy-cache

        trivy image \
        --db-repository ghcr.io/aquasecurity/trivy-db:2 \
        --severity HIGH,CRITICAL \
        --exit-code 0 \
        --no-progress \
        --format json \
        -o trivy-report.json \
        ${IMAGE_NAME}:${IMAGE_TAG}
        '''
            }
        }
    }

    post {

        always {
            script {
                if (fileExists('trivy-report.json')) {
                    archiveArtifacts artifacts: 'trivy-report.json', fingerprint: true
                }
            }
            cleanWs()
        }

        success {
            echo "✅ Safe Image"
        }

        failure {
            echo "❌ Build Failed"
        }
    }
}
