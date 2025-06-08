environment {
    // ... keep existing variables ...
    // Remove staging-specific variables
    DEV_PORT = '8084'
    PROD_PORT = '83'
    
    DEV_NETWORK = 'dev-network'
    PROD_NETWORK = 'prod-network'
    
    // Slack configuration
    SLACK_CHANNEL = 'depos-project'
}

parameters {
    choice(name: 'DEPLOY_ENV', choices: ['development', 'production'], description: 'Select deployment environment')
}

// Add Slack notification function
def notifySlack(String buildStatus = 'STARTED') {
    def color = 'good'
    if (buildStatus == 'FAILURE') {
        color = 'danger'
    }
    
    def message = """
        *Build Status:* ${buildStatus}
        *Project:* ${env.JOB_NAME}
        *Build Number:* ${env.BUILD_NUMBER}
        *Environment:* ${params.DEPLOY_ENV}
        *Build URL:* ${env.BUILD_URL}
    """
    
    slackSend(
        channel: "${env.SLACK_CHANNEL}",
        color: color,
        message: message
    )
}

// In the Version Management stage:
if (params.DEPLOY_ENV == 'development') {
    env.APP_ENV = 'development'
    env.NGINX_PORT = env.DEV_PORT
    env.NETWORK_NAME = env.DEV_NETWORK
} else if (params.DEPLOY_ENV == 'production') {
    env.APP_ENV = 'production'
    env.NGINX_PORT = env.PROD_PORT
    env.NETWORK_NAME = env.PROD_NETWORK
}

// Add pipeline stages
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    try {
                        // Your build steps here
                        echo "Building application..."
                        notifySlack('SUCCESS')
                    } catch (Exception e) {
                        notifySlack('FAILURE')
                        throw e
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    try {
                        // Your deployment steps here
                        echo "Deploying to ${params.DEPLOY_ENV}..."
                        notifySlack('SUCCESS')
                    } catch (Exception e) {
                        notifySlack('FAILURE')
                        throw e
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                if (currentBuild.currentResult == 'SUCCESS') {
                    notifySlack('SUCCESS')
                } else {
                    notifySlack('FAILURE')
                }
            }
        }
    }
}

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}