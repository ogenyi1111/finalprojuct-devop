pipeline {
    agent any
    
    environment {
        DEV_PORT = '8084'
        PROD_PORT = '83'
        DEV_NETWORK = 'dev-network'
        PROD_NETWORK = 'prod-network'
        SLACK_CHANNEL = 'depos-project'
        IS_WINDOWS = "${isUnix() ? 'false' : 'true'}"
        DOCKER_IMAGE = 'ikenna2025/final-project'
        DOCKER_TAG = "${params.DEPLOY_ENV == 'production' ? 'prod' : 'dev'}"
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
                    def nginxPort = params.DEPLOY_ENV == 'development' ? env.DEV_PORT : env.PROD_PORT
                    def platform = env.IS_WINDOWS == 'true' ? 'Windows' : 'Unix/Linux/Mac'
                    def composeFile = params.DEPLOY_ENV == 'production' ? 'docker-compose.production.yml' : 'docker-compose.development.yml'

                    if (env.IS_WINDOWS == 'true') {
                        bat """
                            echo Deploying to ${params.DEPLOY_ENV} on ${platform} with port ${nginxPort}
                            docker-compose -f ${composeFile} up -d
                        """
                    } else {
                        sh """
                            echo "Deploying to ${params.DEPLOY_ENV} on ${platform} with port ${nginxPort}"
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

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}