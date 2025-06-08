pipeline {
    agent {
        node {
            label 'master'
        }
    }
    
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
                    bat 'echo Building application on Windows...'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    bat 'echo Deploying to development on Windows...'
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
                    message: 'Build Succeeded on Windows'
                )
            }
        }
        failure {
            script {
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: 'Build Failed on Windows'
                )
            }
        }
    }
}

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}