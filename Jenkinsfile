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
        stage('Deploy to s3') {
            steps {
                script {
                    echo 'Deploying to s3....'
                    //def gitCommitHash = checkout(scm).GIT_COMMIT
                    //def fileName = "OMS_${gitCommitHash}.war"
                    //sh "mv ${WORKSPACE}/target/OMS.war ${WORKSPACE}/target/${fileName}"
                    //sh "aws s3 cp ${WORKSPACE}/target/${fileName} s3://my-bucket-with-jenkins/${fileName}"
                }
            }
        }
        stage('Deploy to AWS instance') {
            steps {
                echo 'Deploying to the instance....'
                script {
                    sshPublisher(
                        continueOnError: false, failOnError: true,
                        publishers: [
                            sshPublisherDesc(
                                configName: "awsinstance",
                                transfers: [    
                                    sshTransfer(
                                        cleanRemote: true,
                                        remoteDirectory: '/app',
                                        sourceFiles: '**/*.war'
                                    ),
                                    sshTransfer(
                                        execCommand: "sudo cp /home/ubuntu/app/target/OMS.war /var/lib/tomcat9/webapps/"
                                    ),
                                    sshTransfer(
                                        execCommand: "sudo chown tomcat:tomcat /var/lib/tomcat9/webapps/OMS.war"
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}
