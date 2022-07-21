pipeline{
    agent any
    
    stages{
        stage("Checkout Repo"){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/adanvmartinez/python-unittest-app.git']]])
                echo 'Checked out Repository...'
            }
        }
        stage("Test App"){
            steps{
                sh 'echo python3 app/testadan.py app/testindex.py'
                echo 'Ran tests...'
            }
        }
        stage('Terraform Format Check') {
            steps{
                sh 'terraform fmt'
            }
        }
        stage('Terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('Check AWS Credentials/Terraform Plan'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    sh 'aws iam list-users'
                    sh 'terraform plan -input=false -out tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                    
                }
            }
        }
    }
}
