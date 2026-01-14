pipeline {
    agent any

    environment {
        NEXUS_URL = 'http://localhost:8081'
        NEXUS_REPO = 'react-repo'
        APP_NAME = 'react-app'
        VERSION = '1.0.0'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    credentialsId: 'github',
                    url: 'https://github.com/swetha-200160/react-.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

    stage('SonarQube Code Analysis') {
    steps {
        withSonarQubeEnv('SonarQube') {
            bat 'sonar-scanner -Dsonar.projectKey=react-app -Dsonar.projectName=ReactApp -Dsonar.sources=src'
        }
    }
}



        stage('Build React App') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Create Artifact') {
            steps {
                bat '''
                powershell Compress-Archive -Path build\\* -DestinationPath react-build-%VERSION%.zip
                '''
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                bat """
                curl -u admin:admin123 ^
                --upload-file react-build-%VERSION%.zip ^
                %NEXUS_URL%/repository/%NEXUS_REPO%/react/react-build-%VERSION%.zip
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %APP_NAME%:%VERSION% .'
            }
        }

        stage('Deploy Container') {
            steps {
                bat '''
                docker stop react-app || exit 0
                docker rm react-app || exit 0
                docker run -d -p 3000:80 --name react-app react-app:1.0.0
                '''
            }
        }
    }
}
