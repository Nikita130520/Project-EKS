pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'jenkins-eks-cluster'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')   // Store in Jenkins credentials
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-repo/terraform-eks.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan Terraform') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Terraform') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Configure Kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl cluster-info
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f kubernetes/deployment.yaml'
                sh 'kubectl apply -f kubernetes/service.yaml'
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}
