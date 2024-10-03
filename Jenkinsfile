pipeline {
    agent {
        node {
          label 'maven'
    }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }

    stages {
        stage('Build stage') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}

