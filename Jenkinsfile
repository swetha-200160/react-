pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
        sonarRunner 'SonarScanner'
    }

    stages {

        stage('Pull Code') {
            steps {
                git url: 'https://github.com/swetha-200160/react-.git',
                    branch: 'master'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm install --legacy-peer-deps'
            }
        }

        stage('Build React App') {
            steps {
                bat 'npm run build'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat """
                    sonar-scanner ^
                    -Dsonar.projectKey=react-app ^
                    -Dsonar.projectName=React-App ^
                    -Dsonar.sources=src
                    """
                }
            }
        }

        stage('Upload Build to Nexus') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    bat '''
                    tar -cvf react-build.tar build
                    curl -u %NEXUS_USER%:%NEXUS_PASS% ^
                    --upload-file react-build.tar ^
                    http://localhost:8081/repository/react-builds/react-nexus-demo/react-build.tar
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ React build analyzed by SonarQube and uploaded to Nexus successfully'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
