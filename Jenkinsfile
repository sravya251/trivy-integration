pipeline {
    agent any

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:vuln .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                trivy image \
                --exit-code 1 \
                --severity HIGH,CRITICAL \
                myapp:vuln
                '''
            }
        }

    }
}
