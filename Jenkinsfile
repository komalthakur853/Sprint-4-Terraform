pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy the infrastructure')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
        TERRAFORM_DIR = "AWS-Network"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: 'https://github.com/komalthakur853/Sprint-4-Terraform.git']],
                    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: "${env.TERRAFORM_DIR}"]]
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
                dir(env.TERRAFORM_DIR) {
                    sh 'pwd'
                    sh 'ls -la'
                    sh 'cat main.tf || echo "main.tf not found"'
                }
            }
        }

        stage('Initializing Terraform') {
            steps {
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform init || (echo "Terraform init failed"; exit 1)'
                }
            }
        }

        stage('Formatting Terraform Code') {
            steps {
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform fmt -check || echo "Terraform fmt check failed"'
                }
            }
        }

        stage('Validating Terraform') {
            steps {
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform validate || (echo "Terraform validation failed"; exit 1)'
                }
            }
        }

        stage('Previewing the Infra using Terraform') {
            steps {
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform plan -out=tfplan || (echo "Terraform plan failed"; exit 1)'
                }
                input(message: "Are you sure to proceed with applying the changes?", ok: "Apply")
            }
        }

        stage('Applying Terraform Configuration') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform apply -auto-approve tfplan || (echo "Terraform apply failed"; exit 1)'
                }
            }
        }

        stage('Destroy Terraform Infrastructure') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                input(message: "Do you want to destroy the infrastructure?", ok: "Destroy")
                dir(env.TERRAFORM_DIR) {
                    sh 'terraform destroy -auto-approve || (echo "Terraform destroy failed"; exit 1)'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'The Pipeline failed :('
        }
        success {
            echo 'The Pipeline completed successfully!'
        }
    }
}
