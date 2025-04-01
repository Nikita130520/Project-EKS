pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'jenkins-eks-cluster'
        AWS_CREDENTIALS = credentials('AWS_CREDENTIALS') // Load AWS keys
    }

    stages {
        stage('Setup AWS Credentials') {
            steps {
                sh '''
                echo "$AWS_CREDENTIALS" > aws_credentials.txt
                export $(cat aws_credentials.txt | xargs)
                aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                aws configure set region $AWS_REGION
                rm -f aws_credentials.txt
                '''
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh '''
                cd terraform
                terraform init
                '''
            }
        }

        stage('Plan Terraform') {
            steps {
                sh '''
                cd terraform
                terraform plan -out=tfplan
                '''
            }
        }

        stage('apply Terraform') {
            steps {
                sh '''
                cd terraform
                terraform apply -auto-approve
                '''
            }
        }
   }
}
