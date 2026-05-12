pipeline {
    agent any

    options {
        retry(2)
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
    }

    environment {
        IMAGE_NAME = "myapp"
        IMAGE_TAG  = "latest"
        TRIVY_CACHE_DIR = "/var/lib/jenkins/trivy-cache"
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

        stage('Prepare Trivy Cache') {
            steps {
                sh """
                mkdir -p ${TRIVY_CACHE_DIR}
                """
            }
        }

        stage('Trivy Scan - Image') {
            steps {
                retry(2) {
                    sh """
                    trivy image \
                    --cache-dir ${TRIVY_CACHE_DIR} \
                    --db-repository ghcr.io/aquasecurity/trivy-db:2 \
                    --severity HIGH,CRITICAL \
                    --exit-code 1 \
                    --no-progress \
                    --format json \
                    -o trivy-report.json \
                    ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
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
        }

        success {
            echo '✅ Image is safe'
        }

        failure {
            echo '❌ Build failed'
        }

        cleanup {
            cleanWs()
        }
    }
}
