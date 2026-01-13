pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token1',
                    url: 'https://github.com/swetha-200160/react.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t react-app:latest .'
            }
        }

        stage('Deploy') {
            steps {
                bat '''
                docker stop react-app || exit 0
                docker rm react-app || exit 0
                docker run -d -p 3000:80 --name react-app react-app:latest
                '''
            }
        }
    }
}
