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
        stage('Build') {
            steps {
                script {
                    try {
                        echo "Building application..."
                        // Your build steps here
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
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
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'good',
                    message: "Build Status: SUCCESS\nProject: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nEnvironment: ${params.DEPLOY_ENV}\nBuild URL: ${env.BUILD_URL}"
                )
            }
        }
        failure {
            script {
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: "Build Status: FAILURE\nProject: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nEnvironment: ${params.DEPLOY_ENV}\nBuild URL: ${env.BUILD_URL}"
                )
            }
        }
    }
}

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}