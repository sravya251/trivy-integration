pipeline {
    agent any

    options {
        retry(2)
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "latest"
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

        stage('Trivy Scan - Image') {
            steps {
                sh """
                trivy image --severity HIGH,CRITICAL \
                --exit-code 1 \
                --format json \
                -o trivy-report.json \
                ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }

    post {
        always {
            script {
                if (fileExists('trivy-report.json')) {
                    archiveArtifacts artifacts: 'trivy-report.json'
                }
            }
        }

        success {
            echo '✅ Safe image'
        }

        failure {
            echo '❌ Build failed'
        }
    }
}
