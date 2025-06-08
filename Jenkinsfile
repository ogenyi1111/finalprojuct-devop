pipeline {
    agent any
    
    environment {
        DEV_PORT = '8084'
        PROD_PORT = '83'
        SLACK_CHANNEL = 'depos-project'
        IS_WINDOWS = "${isUnix() ? 'false' : 'true'}"
        DOCKER_IMAGE = 'ikenna2025/final-project'
        DOCKER_TAG = "${params.DEPLOY_ENV == 'production' ? 'production' : 'development'}"
    }
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['development', 'production'], description: 'Select deployment environment')
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
                    if (env.IS_WINDOWS == 'true') {
                        bat 'echo Building application on Windows...'
                    } else {
                        sh 'echo "Building application on Unix/Linux/Mac..."'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def composeFile = params.DEPLOY_ENV == 'production' ? 'docker-compose.production.yml' : 'docker-compose.development.yml'
                    
                    if (env.IS_WINDOWS == 'true') {
                        bat "docker-compose -f ${composeFile} build"
                    } else {
                        sh "docker-compose -f ${composeFile} build"
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    def composeFile = params.DEPLOY_ENV == 'production' ? 'docker-compose.production.yml' : 'docker-compose.development.yml'
                    def envName = params.DEPLOY_ENV
                    def port = envName == 'production' ? env.PROD_PORT : env.DEV_PORT
                    def platform = env.IS_WINDOWS == 'true' ? 'Windows' : 'Unix/Linux/Mac'

                    if (env.IS_WINDOWS == 'true') {
                        bat """
                            echo Deploying to ${envName} on ${platform} with port ${port}
                            docker-compose -f ${composeFile} up -d
                        """
                    } else {
                        sh """
                            echo "Deploying to ${envName} on ${platform} with port ${port}"
                            docker-compose -f ${composeFile} up -d
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                def platform = env.IS_WINDOWS == 'true' ? 'Windows' : 'Unix/Linux/Mac'
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'good',
                    message: "Build and Deploy Succeeded on ${platform} - Environment: ${params.DEPLOY_ENV}"
                )
            }
        }
        failure {
            script {
                def platform = env.IS_WINDOWS == 'true' ? 'Windows' : 'Unix/Linux/Mac'
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: "Build or Deploy Failed on ${platform} - Environment: ${params.DEPLOY_ENV}"
                )
            }
        }
        always {
            script {
                // Cleanup old containers and images
                if (env.IS_WINDOWS == 'true') {
                    bat 'docker system prune -f'
                } else {
                    sh 'docker system prune -f'
                }
            }
        }
    }
}
