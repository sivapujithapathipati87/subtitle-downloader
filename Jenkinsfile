pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        //clone the source code from git
        stage('Clone sources') {
            steps {
               git 'https://github.com/sivapujithapathipati87/subtitle-downloader.git'
            }
        }
        // build the code using mvn
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        //sonarqube code quality check
        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonarqube') {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=java-application\
                        -Dsonar.host.url=http://laoclalhost:9000 \
                        -Dsonar.login=sqp_5ecda522e2bfd890796bbe764381d30dae231b99
                    '''
                }
            }
        }
        // docker image build using dockerfile
        stage('Docker Build') {
            steps {
                sh 'docker build -t java-application .'
            }
        }
        //docker image push into docker hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker123', usernameVariable: 'sivapujitha', passwordVariable: 'Rakhi#123$')]) {
                        sh 'docker login -u sivapujitha -p Rakhi#123$'
                    }
                    sh 'docker tag java-application sivapujitha/java-application:latest'
                    sh 'docker push sivapujitha/java-application:latest'
                }
            }
        }
        //run the container using docker image 
        stage('Run') {
            steps {
                sh 'docker run -d -p 8000:8000 --name java-application java-application'
            }
        }
        //docker image scanning using trivy
         stage('Trivy image scan') {
            steps {
                sh 'trivy image java-application'
            }
        }
    }
    //email notification
    post {
           success {
                    archiveArtifacts artifacts: '**/subtitle-downloader*.jar'
                    junit testResults: '**/TEST-*.xml'
                    mail subject: 'build stage succeded',
                          to: 'pujisiri2008@gmail.com',
                          body: "Refer to $BUILD_URL for more details"
            }
           failure {
                    mail subject: 'build stage failed',
                         to: 'pujisiri2008@gmail.com',
                         body: "Refer to $BUILD_URL for more details"
                }
        }
    }
}
