pipeline {
    agent any
    environment {
        // Corrected variable name
        DOCKER_CREDS = credentials('docker123')
        DOCKER_IMAGE = 'sivapujitha'
        IMAGE_NAME = 'java-application'
        IMAGE_TAG = 'latest' 
    }
    tools {
        maven 'maven'
    }
    stages {
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
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        //docker image push into docker hub
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker123', usernameVariable: 'DOCKER_CREDS_USR', passwordVariable: 'DOCKER_CREDS_PSW')]) {
                        sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW'
                    }
                    sh 'docker tag react $DOCKER_IMAGE/$IMAGE_NAME:$IMAGE_TAG'
                    sh 'docker push $DOCKER_IMAGE/$IMAGE_NAME:$IMAGE_TAG'

                }
            }
        }
        //run the container using docker image 
        stage('Run') {
            steps {
                sh 'docker run -d -p 8000:8000 --name $IMAGE_NAME $IMAGE_NAME'
            }
        }
        //docker image scanning using trivy
         stage('Trivy image scan') {
            steps {
                sh 'trivy image $IMAGE_NAME'
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
