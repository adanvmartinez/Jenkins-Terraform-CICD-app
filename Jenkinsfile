pipeline{
    agent any
    
    stages{
        stage("Checkout Repo"){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/adanvmartinez/python-unittest-app.git']]])
                echo 'Checked out Repository...'
            }
        }
        stage("Build App"){
            steps{
                sh 'python3 app/testadan.py app/testindex.py'
                echo 'Ran tests...'
            }
        }
        stage('Terraform format check') {
            steps{
                sh 'terraform fmt'
            }
        }
        stage('Terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('Check AWS Credentials'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    sh 'aws iam list-users'
                    
                }
            }
        }
        stage('Terraform plan'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    sh 'terraform plan'
                    
                }
            }
        }
        // stage('terraform apply') {
        //     steps{
        //         sh 'terraform apply --auto-approve'
        //     }
        // }
    }
}