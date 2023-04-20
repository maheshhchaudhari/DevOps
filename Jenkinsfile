pipeline{
    agent any
    stages{
        stage("TF Init"){
            steps{
                echo "Executing Terraform Init"
                sh 'terraform init'
            }
        }
        stage("TF Validate"){
            steps{
                echo "Validating Terraform Code"
                 sh 'terraform validate'
            }
        }
        stage("TF Plan"){
            steps{
                echo "Executing Terraform Plan"
                 sh 'terraform plan'
            }
        }
        stage("TF Apply"){
            steps{
                echo "Executing Terraform Apply"
                sh 'terraform apply -auto-approve'
            }
        }
        stage("Invoke Lambda"){
            steps{
                echo "Invoking your AWS Lambda https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway-tutorial.html"
                 sh '''aws lambda invoke --function-name lambda_function_Mahesh out --log-type Tail --query 'LogResult' --output text |  base64 -d'''
            }
        }
    }
}
