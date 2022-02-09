pipeline {
    agent { node { label 'master' } }
    stages {
        stage('checkout') {
            steps {
                 git branch: 'main', url: 'https://github.com/ziobombo/KFonEKS.git'
            }
        }
        stage('Plan') {
            
            steps {
                sh 'docker run -it --volume=terraform:/config  hashicorp/terraform:latest -chdir=/config init -input=false'
            }
        }
    }
}