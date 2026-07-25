pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Choose the Terraform action'
        )
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -reconfigure -input=false'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when {
                expression {
                    params.ACTION == 'plan' || params.ACTION == 'apply'
                }
            }

            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Approve Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                input(
                    message: 'Do you approve Terraform Apply?',
                    ok: 'Apply Infrastructure'
                )
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                echo "Terraform action is --> ${params.ACTION}"
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        stage('Approve Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }

            steps {
                input(
                    message: 'Do you approve Terraform Destroy?',
                    ok: 'Destroy Infrastructure'
                )
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }

            steps {
                echo "Terraform action is --> ${params.ACTION}"
                sh 'terraform destroy -input=false -auto-approve'
            }
        }
    }

    post {
        always {
            sh 'rm -f tfplan'
        }

        success {
            echo "Terraform ${params.ACTION} completed successfully."
        }

        failure {
            echo "Terraform ${params.ACTION} failed."
        }
    }
}
