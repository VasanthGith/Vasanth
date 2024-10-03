pipeline {
    agent {
        node {
          label 'maven'
    }
    }

    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/VasanthGith/Vasanth.git'
            }
        }
    }
}

