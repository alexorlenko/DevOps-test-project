pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
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
        stage('Create docker image') {
            steps {
                sh '''
                  docker rm $(docker ps -aq) 2>/dev/null || true
                  docker images -f "dangling=true" -q | xargs -r docker rmi --force
                  docker build -t oms-application:latest -t oms-application:$GIT_COMMIT_HASH .
                '''
            }
        }
        // stage('Publish docker image to ECR') {
        //     steps{
        //         withCredentials([string(credentialsId: 'ECR_URI', variable: 'ECR_URI')]) {
        //             sh '''
        //                 aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${ECR_URI}
        //                 docker tag oms-application:latest ${ECR_URI}/oms-application:latest
        //                 docker tag oms-application:$GIT_COMMIT_HASH ${ECR_URI}/oms-application:$GIT_COMMIT_HASH
        //                 docker push ${ECR_URI}/oms-application:latest
        //                 docker push ${ECR_URI}/oms-application:$GIT_COMMIT_HASH
        //               '''
        //         }
        //     }
        // }
    }
}
