pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                tool name: 'Maven', type: 'hudson.tasks.Maven'
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
            }
        }
    }
}
