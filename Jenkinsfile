pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['development', 'production'], description: 'Select environment to deploy')
    }

    environment {
        DOCKER_IMAGE = 'ikenna2025/final-project'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_COMPOSE_FILE = "docker-compose.${params.ENV}.yml"
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')
        SLACK_CHANNEL = 'depos-project'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'echo "Building application on Unix..."'
                    } else {
                        bat 'echo "Building application on Windows..."'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    } else {
                        bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    }
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin'
                    } else {
                        bat 'echo %DOCKER_CREDENTIALS_PSW% | docker login -u %DOCKER_CREDENTIALS_USR% --password-stdin'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    } else {
                        bat "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (isUnix()) {
                        sh "echo 'Deploying to production on Unix with port 80'"
                        sh "docker-compose -f docker-compose.production.yml up -d"
                    } else {
                        bat "echo 'Deploying to production on Windows with port 83'"
                        bat "docker-compose -f docker-compose.production.yml up -d"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                if (isUnix()) {
                    sh 'docker system prune -f'
                } else {
                    bat 'docker system prune -f'
                }
            }
        }
        success {
            script {
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'good',
                    message: "Pipeline succeeded! Build: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nDocker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                )
            }
        }
        failure {
            script {
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: "Pipeline failed! Build: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nDocker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                )
            }
        }
    }
}
