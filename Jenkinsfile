pipeline {
    agent any

    environment {
        DOCKER_DEV_REPO = "a516/devops-build-dev"
        DOCKER_PROD_REPO = "a516/devops-build-prod"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/Abhi090595/devops-build.git', credentialsId: 'github-pat'
            }
        }

        stage('Build Docker Image (DEV)') {
            steps {
                sh '''
                docker build -t a516/devops-build-dev:latest .
                '''
            }
        }

        stage('Push to DEV DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-pat', variable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u a516 --password-stdin
                    docker push a516/devops-build-dev:latest
                    '''
                }
            }
        }

        stage('Merge DEV → MAIN for PROD') {
            when {
                branch 'dev'
            }
            steps {
                sh '''
                git checkout main
                git merge dev
                git push origin main
                '''
            }
        }

        stage('Build Docker Image (PROD)') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                docker build -t a516/devops-build-prod:latest .
                '''
            }
        }

        stage('Push to PROD DockerHub') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([string(credentialsId: 'docker-hub-pat', variable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u a516 --password-stdin
                    docker push a516/devops-build-prod:latest
                    '''
                }
            }
        }
    }
}
