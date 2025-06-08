pipeline {
    agent any

    environment {
        DEV_PORT = '8084'
        PROD_PORT = '83'
        DOCKER_IMAGE = 'ikenna2025/final-project'
    }

    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['development', 'production'], description: 'Select the environment')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def composeFile = params.DEPLOY_ENV == 'production' ? 'docker-compose.production.yml' : 'docker-compose.development.yml'

                    if (isUnix()) {
                        sh "docker-compose -f ${composeFile} build"
                    } else {
                        bat "docker-compose -f ${composeFile} build"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def composeFile = params.DEPLOY_ENV == 'production' ? 'docker-compose.production.yml' : 'docker-compose.development.yml'

                    if (isUnix()) {
                        sh "docker-compose -f ${composeFile} up -d"
                    } else {
                        bat "docker-compose -f ${composeFile} up -d"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful"
        }
        failure {
            echo "Deployment failed"
        }
        always {
            script {
                if (isUnix()) {
                    sh 'docker system prune -f'
                } else {
                    bat 'docker system prune -f'
                }
            }
        }
    }
}
