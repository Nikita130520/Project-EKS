pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'jenkins-eks-cluster'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-repo/terraform-eks.git'
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withAWS(credentials: 'AWS_CREDENTIALS', region: "${AWS_REGION}") {
                    sh '''
                    aws sts get-caller-identity
                    aws configure list
                    '''
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Configure Kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
                kubectl cluster-info || echo "Cluster connection failed!"
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                dir('kubernetes') {
                    sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed! Check logs for details."
        }
    }
}
