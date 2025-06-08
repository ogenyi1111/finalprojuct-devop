pipeline {
    agent any
    
    environment {
        DEV_PORT = '8084'
        PROD_PORT = '83'
        DEV_NETWORK = 'dev-network'
        PROD_NETWORK = 'prod-network'
        SLACK_CHANNEL = 'depos-project'
        IS_WINDOWS = "${isUnix() ? 'false' : 'true'}"
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
        
        stage('Deploy') {
            steps {
                script {
                    if (env.IS_WINDOWS == 'true') {
                        bat 'echo Deploying to development on Windows...'
                    } else {
                        sh 'echo "Deploying to development on Unix/Linux/Mac..."'
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
                    message: "Build Succeeded on ${platform}"
                )
            }
        }
        failure {
            script {
                def platform = env.IS_WINDOWS == 'true' ? 'Windows' : 'Unix/Linux/Mac'
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: "Build Failed on ${platform}"
                )
            }
        }
    }
}

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}