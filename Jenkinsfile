pipeline {

    agent any
 
    environment {

        IMAGE_NAME = "myapp"

        IMAGE_TAG = "latest"

    }
 
    stages {
 
        stage('Clone Code') {

            steps {

                git branch: 'master', url: 'https://github.com/sravya251/trivy-integration.git'

            }

        }
 
        stage('Build Docker Image') {

            steps {

                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'

            }

        }
 
        stage('Verify Image') {

            steps {

                sh 'docker images'

            }

        }
 
        stage('Trivy Scan - Image') {

            steps {

                sh '''

                trivy image \

                --scanners vuln \

                --ignore-unfixed \

                --severity CRITICAL \

                --exit-code 1 \

                --format json -o trivy-report.json \

                ${IMAGE_NAME}:${IMAGE_TAG}

                '''

            }

        }

    }
 
    post {

        always {

            archiveArtifacts artifacts: 'trivy-report.json', fingerprint: true

        }

        failure {

            echo "❌ Build failed due to vulnerabilities!"

        }

        success {

            echo "✅ Image is safe. Proceed to deploy."

        }

    }

}

 
