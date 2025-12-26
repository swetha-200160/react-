pipeline {
    agent any

    tools {
        nodejs 'NodeJS'   // Configure NodeJS in Jenkins tools
    }

    stages {

        stage('Pull Code') {
            steps {
                git url: 'https://github.com/your-repo/react-nexus-demo.git',
                    branch: 'main'
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
            echo '✅ React build successfully uploaded to Nexus'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
