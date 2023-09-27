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
                def gitCommitHash = checkout(scm).GIT_COMMIT
                def fileName = "OMS_${gitCommitHash}.war"
                sh "mv ${WORKSPACE}/target/OMS.war ${WORKSPACE}/target/${fileName}"
                sh "aws s3 cp ${WORKSPACE}/target/${fileName} s3://my-bucket-with-jenkins/${fileName}"
            }
        }
    }
}
