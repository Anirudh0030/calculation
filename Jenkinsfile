pipeline {
    agent any
     environment {
        PATH = "$PATH:/usr/local/apache-tomcat-8.5.85/bin"
     }
    stages {
        stage('GetCode') {
            steps {
                git 'https://github.com/Anirudh0030/calculation.git'
            }
        }
        stage('Clean') {
            steps {
                sh 'mvn clean'
    }
        }
    stage('Compile') {
            steps {
                sh 'mvn compile'
             }
          }
          stage('Build') {
            steps {
                sh 'mvn install'
             }
          }
    stage('Package') {
            steps {
                sh 'mvn package'
             }
          }
    stage('Quality Gate') {
        steps {
        withSonarQubeEnv('sonarqube-10.1') {
          sh 'mvn sonar:sonar'
         }
       } 
    }   
  stage ('Docker image build'){
        steps{
             script{
                 sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                 sh 'docker image tag $JOB_NAME:v1.$BUILD_ID anirudh03/$JOB_NAME:latest'
                }    
            }
        }
  stage ('Docker image push'){
         steps{
             script{
                    withCredentials([string(credentialsId: 'docker_hub_pass', variable: 'docker_hub')]) {
                    sh 'docker login -u anirudh03 -p ${docker_hub}'
                    sh 'docker image push anirudh03/$JOB_NAME:latest'
                    }
                }
                
            }
        }
  stage ('Kubernetes Deployment'){
         steps{
              script{
                  sh 'kubectl apply -f Calculation.yaml'
                }
            }  
        }
   stage ('Deploy on K8s'){
         steps{
             sshagent(['K8s']) {
             sh "scp -o StrictHostKeyChecking=no Calculation.yaml ubuntu@3.135.1.80:/home/ubuntu" 
             script{
                 try{
                     sh "ubuntu@3.135.1.80 kubectl apply -f ."
                 }  catch(error){
                     sh "ubuntu@3.135.1.80 kubectl create -f ."
                    }
                  }
                }
            }
         }
        }
    }     
    }
}    
