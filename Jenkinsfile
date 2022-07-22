
//Author: Adan Martinez
//Thus automates deployment of infrastructure using Jenkins.
pipeline{
    agent any
    
    stages{
        // stage("Checkout Repo"){
        //     steps{
                
        //         //checkout([$class: 'GitSCM',credentialsId: 'github-api-token', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'git@github.com:adanvmartinez/CICD-pipeline-app.git']]])
                
        //         sh'git clone https://${github-api-token}@github.exampleco.com/org/repo.git'
        //         echo 'Checked out Repository...'
                
        //     }
        // }

        //Runs unit test apps
        stage("Test App"){
            steps{
                sh 'python3 app/testadan.py app/testindex.py'
                echo 'Ran tests...'
            }
        }
        //Checks for any formatting errors in terreform syntax
        stage('Terraform Format Check') {
            steps{
                sh 'terraform fmt'
            }
        }
        //Initializes terraform files
        stage('Terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        //Validate scripts
        stage('Terraform Validate') {
            steps{
                sh 'terraform validate'
            }
        }
        //Make sure we have access to AWS and start terraform planning
        stage('Terraform Plan and Apply'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    sh 'aws iam list-users'
                    sh 'terraform plan -input=false -out tfplan'
                    //sh 'terraform show -no-color tfplan > tfplan.txt'
                    sh 'pwd'
                    sh 'ls -a'
                    sh 'terraform apply --auto-approve'
                    
                }
            }
        }
        //Apply Kubernetes YML file to EKS
        stage('Deploy NGINx Image'){
            steps{
                withAWS(credentials:'jenkins-aws-credentials',region:'us-west-1'){
                    //sh 'kubectl apply -f deployment.yml'
                    sh 'aws eks --region us-west-1 update-kubeconfig --name terrafrom-lab-cluster'
                    //sh 'kubectl get pods --all-namespaces'
                    //sh 'kubectl config use-context arn:aws:eks:us-west-1:858952941568:cluster/terrafrom-lab-cluster'
                    sh 'kubectl get pods --all-namespaces'
                    //sh 'kubectl apply -f deployment.yml'
                }
            }
        }
        //Destoy infra
        stage('Destoy'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    echo 'Destroy Stage'
                    //sh 'terraform destroy --auto-approve'
                    
                    
                }
            }
        }
    }
        
}
