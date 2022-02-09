pipeline {
    stages {
        stage('checkout') {
            steps {
                 script{
                        {
                            git "https://github.com/ziobombo/KFonEKS.git"
                        }
                    }
                }
            }
        }
        stage('Plan') {
            
            steps {
                sh 'docker run -it --volume=terraform:/config  hashicorp/terraform:latest -chdir=/config init'
            }
        }
    }
}