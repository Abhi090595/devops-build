pipeline {
    agent any

    environment {
        
        DEV_REPO  = "a516/devops-build-dev"
        PROD_REPO = "a516/devops-build-prod"

        DOCKER_CREDS = "dockerhub-creds"
        GIT_CREDS    = "github-creds"

        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout from GitHub') {
            steps {
                checkout scm          
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (env.BRANCH_NAME == "dev") {
                        sh "docker build -t a516/devops-build-dev:latest ."
                    }
                    if (env.BRANCH_NAME == "main") {
                        sh "docker build -t a516/devops-build-prod:latest ."
                    }
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "dockerhub-creds",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                }

                script {
                    if (env.BRANCH_NAME == "dev") {
                        sh "docker push a516/devops-build-dev:latest"
                    }
                    if (env.BRANCH_NAME == "main") {
                        sh "docker push a516/devops-build-prod:latest"
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    if (env.BRANCH_NAME == "dev") {
                        sh "./deploy.sh dev"
                    }
                    if (env.BRANCH_NAME == "main") {
                        sh "./deploy.sh prod"
                    }
                }
            }
        }
    }
}
