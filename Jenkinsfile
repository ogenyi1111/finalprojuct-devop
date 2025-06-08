pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['development', 'production'], description: 'Select environment to deploy')
    }

    environment {
        DOCKER_IMAGE = 'ikenna2025/final-project'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
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
                    def tagCmd = "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    def tagProdCmd = "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:production"

                    if (isUnix()) {
                        sh tagCmd
                        if (params.ENV == 'production') {
                            sh tagProdCmd
                        }
                    } else {
                        bat tagCmd
                        if (params.ENV == 'production') {
                            bat tagProdCmd
                        }
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
                    def pushTagCmd = "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    def pushProdCmd = "docker push ${DOCKER_IMAGE}:production"

                    if (isUnix()) {
                        sh pushTagCmd
                        if (params.ENV == 'production') {
                            sh pushProdCmd
                        }
                    } else {
                        bat pushTagCmd
                        if (params.ENV == 'production') {
                            bat pushProdCmd
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def composeFile = "docker-compose.${params.ENV}.yml"
                    if (isUnix()) {
                        sh "echo 'Deploying to ${params.ENV} on Unix...'"
                        sh "docker-compose -f ${composeFile} up -d"
                    } else {
                        bat "echo 'Deploying to ${params.ENV} on Windows...'"
                        bat "docker-compose -f ${composeFile} up -d"
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
