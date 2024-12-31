pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the infrastructure')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = "ap-south-1"
        TERRAFORM_DIR         = "AWS-Network"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/komalthakur853/Sprint-4-Terraform.git']],
                    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "."]] // Fix directory structure
                ])
            }
        }

        stage('Debug Checkout') {
            steps {
                sh 'pwd'
                sh 'ls -R'
            }
        }

        stage('Diagnostic Information') {
            steps {
                sh 'pwd'
                sh 'id'
                sh 'terraform version'
                sh 'ls -R'
            }
        }

        stage('Navigate to Terraform Directory') {
            steps {
                dir('AWS-Network') {
                    sh 'pwd'
                    sh 'ls -la'
                    sh 'cat main.tf || echo "main.tf not found"'
                }
            }
        }

        stage('Initializing Terraform') {
            steps {
                dir('AWS-Network') {
                    sh 'terraform init || (echo "Terraform initialization failed"; exit 1)'
                }
            }
        }

        stage('Formatting Terraform Code') {
            steps {
                dir('AWS-Network') {
                    script {
                        try {
                            sh 'terraform fmt -check'
                        } catch (Exception e) {
                            error("Formatting failed: ${e.message}")
                        }
                    }
                }
            }
        }

        stage('Validating Terraform') {
            steps {
                dir('AWS-Network') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Previewing the Infra using Terraform') {
            steps {
                dir('AWS-Network') {
                    sh 'terraform plan -out=tfplan || (echo "Terraform plan failed"; exit 1)'
                }
            }
        }

        stage('Applying Terraform Configuration') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('AWS-Network') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Destroy Terraform Infrastructure') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir('AWS-Network') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
            echo "The Pipeline ${currentBuild.currentResult}"
        }
    }
}
