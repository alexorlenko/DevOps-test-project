pipeline {
    agent any
    tools {
        maven 'Maven'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                echo "${WORKSPACE}"
                sh "ls -la ${WORKSPACE}"
                //sh "aws s3 cp ${WORKSPACE}/ s3://myflaskappbucket1"
            }
        }
    }
}
