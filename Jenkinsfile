pipeline {
    agent any
    environment {
        SUDO_PASSWORD = credentials('sudo_password')
    }
    stages {
        stage('Add Users') {
            agent {
                node {
                    label 'vm3'
                }
            }
            steps {
                sh('sed -i "s/SUDO_PASSWORD/${SUDO_PASSWORD_PSW}/g" CreateUsers.sh')

                sh 'chmod +x CreateUsers.sh'
                sh './CreateUsers.sh'
            }
        }

        stage('Install Nginx using Ansible') {
            steps {
                script {
                    sh 'ansible-playbook InstallNginx.yml'
                }
            }
        }

        stage('Send Email Notification') {
            agent {
                node {
                    label 'vm3'
                }
            }
            steps {
                script {
                    sh 'chmod +x GroupMembers.sh'
                    def groupMembers = sh(script: './GroupMembers.sh', returnStdout: true).trim()

                    def currentDateTime = new Date().format("yyyy-MM-dd HH:mm:ss", TimeZone.getTimeZone('UTC'))

                    def emailSubject = "Pipeline Execution Notification"
                    def emailBody = """
                    Pipeline executed at: ${currentDateTime}
                    Pipeline status: ${currentBuild.currentResult}
                    ${groupMembers}
                    """

                    emailext to: 'sherif.emad10911@gmail.com',
                            subject: emailSubject,
                            body: emailBody
                }
            }
        }
    }
    post {
        always {
            echo 'The pipeline has completed execution.'
        }
    }
}
