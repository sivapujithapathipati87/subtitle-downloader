pipeline {
    agent any
    environment {
         //sonarqube env variables
        SONAR_SCANNER='/opt/sonar-scanner' 
        SONAR_URL= 'http://localhost:9000'
        SONAR_PROJECTKEY='java-application'
        SONAR_LOGIN='sqp_5ecda522e2bfd890796bbe764381d30dae231b99'
        // harbor env variables
        HARBOR = credentials('harbour123')
        HARBOR_REGISTRY = 'new-harbor.duckdns.org'
        HARBOR_PROJECT = 'new_project'
        IMAGE_NAME = 'java-application'
        IMAGE_TAG = 'latest'
        IMAGE_PORT= '8000:8000'     
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
                         -Dsonar.projectKey=$SONAR_PROJECTKEY \
                         -Dsonar.host.url=$SONAR_URL \
                         -Dsonar.login=$SONAR_LOGIN
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
                sh 'docker run -d -p $IMAGE_PORT --name $IMAGE_NAME $IMAGE_NAME'
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
            // Send Slack notification on successful build
            slackSend(
                color: '#00FF00',
                message: "Build successful: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
            )
        }
        failure {
            // Send Slack notification on build failure
            slackSend(
                color: '#FF0000',
                message: "Build failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
            )
        }
    }  
}
