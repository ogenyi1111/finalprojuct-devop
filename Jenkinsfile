pipeline {
    agent any
    
    environment {
        DEV_PORT = '8084'
        PROD_PORT = '83'
        DEV_NETWORK = 'dev-network'
        PROD_NETWORK = 'prod-network'
        SLACK_CHANNEL = 'depos-project'
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
                    bat 'echo Building application...'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    try {
                        if (params.DEPLOY_ENV == 'development') {
                            env.APP_ENV = 'development'
                            env.NGINX_PORT = env.DEV_PORT
                            env.NETWORK_NAME = env.DEV_NETWORK
                        } else if (params.DEPLOY_ENV == 'production') {
                            env.APP_ENV = 'production'
                            env.NGINX_PORT = env.PROD_PORT
                            env.NETWORK_NAME = env.PROD_NETWORK
                        }
                        
                        echo "Deploying to ${params.DEPLOY_ENV}..."
                        // Your deployment steps here
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                def message = "Build Succeeded"
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'good',
                    message: message
                )
            }
        }
        failure {
            script {
                def message = "Build Failed"
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: message
                )
            }
        }
    }
}

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}