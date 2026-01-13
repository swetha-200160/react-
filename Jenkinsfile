pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
              stage('Checkout') {
    steps {
        git branch: 'master',
            credentialsId: 'github-token',
            url: 'https://github.com/swetha-200160/react.git'
    }
}

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
                docker stop react-app || true
                docker rm react-app || true
                docker run -d -p 3000:80 --name react-app react-app:latest
                '''
            }
        }
    }
}
