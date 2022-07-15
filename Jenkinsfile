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
                sh 'python3 testadan.py testindex.py'
                echo 'Ran tests...'
            }
        }
    }
