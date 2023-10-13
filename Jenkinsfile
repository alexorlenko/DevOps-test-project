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
                sh '''
                  docker rm $(docker ps -aq) 2>/dev/null || true
                  docker images -f "dangling=true" -q | xargs -r docker rmi --force
                  docker build -t oms-application:latest -t oms-application:$GIT_COMMIT_HASH .
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'docker run oms-application:latest mvn test'
            }
        }
        stage('Publish docker image to ECR') {
            steps{
                withCredentials([string(credentialsId: 'ECR_URI', variable: 'ECR_URI')]) {
                    sh '''
                        aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${ECR_URI}
                        docker tag oms-application:latest ${ECR_URI}/oms-application:latest
                        docker tag oms-application:$GIT_COMMIT_HASH ${ECR_URI}/oms-application:$GIT_COMMIT_HASH
                        docker push ${ECR_URI}/oms-application:latest
                        docker push ${ECR_URI}/oms-application:$GIT_COMMIT_HASH
                      '''
                }
            }
        }
        // stage('Deploy to s3') {
        //     steps {
        //         script {
        //             echo 'Deploying to s3....'
        //             def gitCommitHash = checkout(scm).GIT_COMMIT
        //             def fileName = "OMS_${gitCommitHash}.war"
        //             sh "mv ${WORKSPACE}/target/OMS.war ${WORKSPACE}/target/${fileName}"
        //             sh "aws s3 cp ${WORKSPACE}/target/${fileName} s3://my-bucket-with-jenkins/${fileName}"
        //             sh "mv ${WORKSPACE}/target/${fileName} ${WORKSPACE}/target/OMS.war"
        //         }
        //     }
        // }
        // stage('Deploy to AWS instance') {
        //     steps {
        //         echo 'Deploying to the instance....'
        //         script {
        //             sshPublisher(
        //                 continueOnError: false, failOnError: true,
        //                 publishers: [
        //                     sshPublisherDesc(
        //                         configName: "awsinstance",
        //                         transfers: [    
        //                             sshTransfer(
        //                                 cleanRemote: true,
        //                                 remoteDirectory: '/app',
        //                                 sourceFiles: '**/*.war'
        //                             ),
        //                             sshTransfer(
        //                                 execCommand: "sudo cp /home/ubuntu/app/target/OMS.war /var/lib/tomcat9/webapps/"
        //                             )
        //                         ]
        //                     )
        //                 ]
        //             )
        //         }
        //     }
        // }
    }
}
