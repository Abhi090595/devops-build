pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "a516"
        DEV_REPO  = "devops-build-dev"
        PROD_REPO = "devops-build-prod"
        IMAGE_NAME = "devops-build-react-app"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-build-prod:latest .'
            }
        }

        stage('Push to DEV DockerHub') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag devops-build-react-app:latest a516/devops-build-dev:latest
                    docker push a516/devops-build-dev:latest
                    '''
                }
            }
        }

        stage('Push to PROD DockerHub') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag devops-build-react-app:latest a516/devops-build-prod:latest
                    docker push a516/devops-build-prod:latest
                    '''
                }
            }
        }

        stage('Deploy (PROD only)') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                docker pull a516/devops-build-prod:latest
                /usr/bin/docker-compose down
                /usr/bin/docker-compose up -d
                '''
            }
        }
    }
}
