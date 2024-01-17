pipeline {
    agent {label "LOCAL"}
    stages {
        stage ("Testing"){
            when {branch 'PreProd'}
                steps{
                    echo "This is test A"
                }
            }
        }
        // stage to deploy the build files on the main branch
        stage("Building"){
            when {branch 'main'}
            steps{
                echo "building"
            }
        }

}
