pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    environment {
        APP_NAME = 'java-yearbook'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'milestone-2-jenkins',
                    url: 'https://github.com/musman-create/java-yearbook-project.git'
            }
        }

        stage('Build Java Application') {
            steps {
                dir('java') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${APP_NAME}:${BUILD_NUMBER} ./java'
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker images ${APP_NAME}'
            }
        }
    }

    post {
        success {
            echo 'Java Yearbook Jenkins pipeline completed successfully!'
        }
        failure {
            echo 'Jenkins pipeline failed. Check the console output.'
        }
    }
}
