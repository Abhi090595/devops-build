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
                sh 'docker build -t devops-build-react-app:latest .'
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
                    docker tag $IMAGE_NAME:latest $DOCKER_USER/$DEV_REPO:latest
                    docker push $DOCKER_USER/$DEV_REPO:latest
                    '''
                }
            }
        }

        stage('Push to PROD DockerHub') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag $IMAGE_NAME:latest $DOCKER_USER/$PROD_REPO:latest
                    docker push $DOCKER_USER/$PROD_REPO:latest
                    '''
                }
            }
        }

        stage('Deploy (PROD only)') {
            when {
                branch 'master'
            }
            steps {
                sh '''
                docker pull $DOCKER_USER/$PROD_REPO:latest
                docker-compose down
                docker-compose up -d
                '''
            }
        }
    }
}
