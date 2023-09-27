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
                    def gitCommitHash = checkout(scm).GIT_COMMIT
                    def fileName = "OMS_${gitCommitHash}.war"
                    sh "mv ${WORKSPACE}/target/OMS.war ${WORKSPACE}/target/${fileName}"
                    sh "aws s3 cp ${WORKSPACE}/target/${fileName} s3://my-bucket-with-jenkins/${fileName}"
                }
            }
        }
        stage('Deploy to AWS instance') {
            steps {
                echo 'Deploying to the instance....'
                script {
                    // Ім'я WAR-файлу, яке вам потрібно розгортати
                    def warFileName = "OMS.war"
        
                    // Шлях на локальній машині до WAR-файлу
                    def localWarPath = "${WORKSPACE}/target/${warFileName}"
        
                    // Шлях на віддаленій машині, куди ви хочете розмістити WAR-файл
                    def remoteDirectory = '/var/lib/tomcat9/webapps'
        
                    // Копіювання WAR-файлу через SSH
                    sshPublisher(
                        continueOnError: false,
                        failOnError: true,
                        publishers: [
                            sshPublisherDesc(
                                configName: 'app_server',
                                transfers: [
                                    sshTransfer(
                                        sourceFiles: localWarPath,
                                        remoteDirectory: remoteDirectory
                                    )
                                ]
                            )
                        ]
                    )
        
                    // Виконати команди SSH на віддаленому сервері для розгортання та запуску
                    sshCommand(
                        remote: "app_server",
                        command: [
                            "cd /var/lib/tomcat9/webapps", // Замініть на шлях до директорії на сервері
                            "unzip -q *.war", // Розпакувати WAR-файл
                            "sudo systemctl restart tomcat" // Перезапустити Tomcat (замініть на вашу команду)
                        ].join(' && ')
                    )
                }
            }
        }
    }
}
