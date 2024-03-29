
//Author: Adan Martinez
//Thus automates deployment of infrastructure using Jenkins.
pipeline{
    agent any
    
    stages{
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
                dir('terraform'){
                sh 'pwd'
                sh 'terraform fmt'
                }
            }
        }
        //Initializes terraform files
        stage('Terraform Init') {
            steps{
                dir('terraform'){
                sh 'pwd'
                sh 'terraform init'
                }
            }
        }
        //Validate scripts
        stage('Terraform Validate') {
            steps{
                dir('terraform'){
                sh 'pwd'
                sh 'terraform validate'
                }
            }
        }
        //Make sure we have access to AWS and start terraform planning
        stage('Terraform Plan and Apply'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    dir('terraform'){
                    sh 'pwd'
                    sh 'aws iam list-users'
                    sh 'terraform plan -input=false -out tfplan'
                    //sh 'terraform show -no-color tfplan > tfplan.txt'
                    sh 'pwd'
                    sh 'ls -a'
                    sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        //Build Docker image with the python app and nginx
        // stage('Build NGINX-APP Docker Image'){
        //     steps{
        //         sh 'docker build . -t adan/python-app'
        //         //sh 'docker run --rm -p 5000:5000 app:latest &'
        //         sh 'eval $(minikube -p minikube docker-env)'
        //         sh 'kubectl create -f app.yml'
        //     }
        // }

        //Apply Kubernetes YML file to EKS
        stage('Deploy NGINx Image'){
            steps{
                withAWS(credentials:'jenkins-aws-credentials',region:'us-west-1'){
                    //sh 'kubectl apply -f deployment.yml'
                    sh 'aws eks --region us-west-1 update-kubeconfig --name terraform-cluster'
                    //sh 'kubectl get pods --all-namespaces'
                    //sh 'kubectl config use-context arn:aws:eks:us-west-1:858952941568:cluster/terrafrom-lab-cluster'
                    sh 'kubectl get services'
                    sh 'kubectl delete services nginx-service'


                    sh 'kubectl get nodes'
                    sh 'kubectl get pods --all-namespaces'
                    sh 'kubectl apply -f deployment.yml'
                    sh 'kubectl get deployments python-unittest-app'
                    sh 'kubectl describe deployments python-unittest-app'
                    sh 'kubectl get replicasets'
                    sh 'kubectl describe replicasets'

                    sh 'kubectl expose deployment python-unittest-app  --port=80 --target-port=80  --name=nginx-service --type=LoadBalancer'

                    sh 'kubectl get service nginx-service' 
                    sh 'kubectl describe service nginx-service'

                    sh 'kubectl get nodes'
                    sh 'kubectl get pods --output=wide'

                }
            }
        }
        //Destoy infra
        stage('Destroy'){
            steps{
                withAWS(credentials:'jenkins-test-app-credentials',region:'us-west-1'){
                    dir('terraform'){
                        echo 'Destroy Stage'
                        sh 'terraform destroy --auto-approve'
                    }
                    
                }
            }
        }
    }
        
}
