pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
        sonarRunner 'SonarScanner'
    }

    environment {
        SONAR_PROJECT_KEY  = 'react-app'
        SONAR_PROJECT_NAME = 'ReactApp'
        NEXUS_REPO_URL     = 'http://localhost:8081/repository/react-repo'
        ARTIFACT_NAME      = 'react-build-1.0.0.zip'
    }

    stages {

        stage('Checkout') {
            steps {
                git credentialsId: 'github',
                    url: 'https://github.com/swetha-200160/react-.git',
                    branch: 'master'
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
                    withCredentials([
                        string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')
                    ]) {
                        bat """
                        sonar-scanner ^
                        -Dsonar.projectKey=%SONAR_PROJECT_KEY% ^
                        -Dsonar.projectName=%SONAR_PROJECT_NAME% ^
                        -Dsonar.sources=src ^
                        -Dsonar.host.url=http://localhost:9000 ^
                        -Dsonar.token=%SONAR_TOKEN%
                        """
                    }
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
                bat """
                if exist %ARTIFACT_NAME% del %ARTIFACT_NAME%
                powershell Compress-Archive -Path build\\* -DestinationPath %ARTIFACT_NAME%
                """
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'nexus-creds',
                        usernameVariable: 'NEXUS_USER',
                        passwordVariable: 'NEXUS_PASS'
                    )
                ]) {
                    bat """
                    curl -u %NEXUS_USER%:%NEXUS_PASS% ^
                    --upload-file %ARTIFACT_NAME% ^
                    %NEXUS_REPO_URL%/react/%ARTIFACT_NAME%
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t react-app:latest .'
            }
        }

        stage('Deploy Container') {
            steps {
                bat '''
                docker rm -f react-app || exit 0
                docker run -d -p 3000:80 --name react-app react-app:latest
                '''
            }
        }
    }
}
