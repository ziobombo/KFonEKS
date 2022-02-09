pipeline {
    agent { node { label 'master' } }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('checkout') {
            steps {
                 git branch: 'main', url: 'https://github.com/ziobombo/KFonEKS.git'
            }
        }
        stage('Init') {
            steps {
                sh 'docker run --volume=$PWD/terraform:/config  hashicorp/terraform:latest -chdir=/config init -input=false'
            }
        }
        stage('Apply') {
            steps {
                sh 'docker run --volume=$PWD/terraform:/config  hashicorp/terraform:latest -chdir=/config apply -input=false'
            }
        }
    }
}