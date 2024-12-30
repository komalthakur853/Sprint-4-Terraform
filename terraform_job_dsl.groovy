pipelineJob('terraform-aws-network') {
    description('Pipeline for managing AWS Network Infrastructure using Terraform')

    parameters {
        choiceParam('ACTION', ['apply', 'destroy'], 'Choose whether to apply or destroy the infrastructure')
        stringParam('GIT_URL', 'https://github.com/komalthakur853/Sprint-4-Terraform.git', 'Git repository URL')
        stringParam('BRANCH', 'main', 'Git branch to checkout')
        stringParam('TERRAFORM_DIR', '.', 'Directory containing Terraform files')
        stringParam('AWS_REGION', 'ap-south-1', 'AWS region to target')
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('${GIT_URL}')
                    }
                    branch('${BRANCH}')
                    extensions {
                        relativeTargetDirectory('Sprint-4-Terraform')
                    }
                }
            }
            scriptPath('Jenkinsfile')
        }
    }

    environmentVariables {
        env('AWS_ACCESS_KEY_ID', 'AWS_ACCESS_KEY_ID') // Injecting AWS Access Key ID
        env('AWS_SECRET_ACCESS_KEY', 'AWS_SECRET_ACCESS_KEY') // Injecting AWS Secret Access Key
        env('AWS_DEFAULT_REGION', '${AWS_REGION}')
        env('TERRAFORM_DIR', '${TERRAFORM_DIR}')
    }

    properties {
        disableConcurrentBuilds()
        buildDiscarder {
            strategy {
                logRotator {
                    numToKeepStr('10')
                    daysToKeepStr('30')
                }
            }
        }
    }
}
