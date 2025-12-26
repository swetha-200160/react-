pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    stages {

        stage('Pull Code') {
            steps {
                git url: 'https://github.com/swetha-200160/react-.git',
                    branch: 'master'
            }
        }

        stage('Build') {
            steps {
                bat 'npm run build'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
    bat 'mvn clean verify'
}

            }
        }

       stage('Deploy to Nexus') {
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

    post {
        success {
            echo '✅ Pull → Build → Sonar → Nexus SUCCESS'
        }
        failure {
            echo '❌ Pipeline FAILED'
        }
    }
}
