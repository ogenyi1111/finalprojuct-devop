environment {
    // ... keep existing variables ...
    // Remove staging-specific variables
    DEV_PORT = '8084'
    PROD_PORT = '83'
    
    DEV_NETWORK = 'dev-network'
    PROD_NETWORK = 'prod-network'
}

parameters {
    choice(name: 'DEPLOY_ENV', choices: ['development', 'production'], description: 'Select deployment environment')
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

// In the Deploy stage:
export NGINX_PORT=${DEPLOY_ENV == 'development' ? '8084' : '83'}