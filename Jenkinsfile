pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'pavan176/my-flask-app'  // Replace with your Docker image name
        DOCKER_TAG = 'latest'
        REGISTRY_CREDENTIALS = 'docker-hub-credentials'  // Jenkins Docker Hub credentials ID
        K8S_CREDENTIALS = 'k8s-credentials'  // Kubernetes cluster credentials ID
        K8S_DEPLOYMENT_NAME = 'my-flask-app'  // Kubernetes deployment name
        K8S_NAMESPACE = 'default'  // Kubernetes namespace (if different, change it)
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository from GitHub (or any VCS)
                git branch: 'main', url: 'https://github.com/your-repo/my-flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using Dockerfile
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    }
                    // Push the Docker image to Docker Hub
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes deployment using kubectl (requires kubeconfig or K8s credentials)
                    withCredentials([kubeconfigFile(credentialsId: "${K8S_CREDENTIALS}", variable: 'KUBECONFIG')]) {
                        sh "kubectl set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_IMAGE}:${DOCKER_TAG} --namespace=${K8S_NAMESPACE}"
                        // Optionally, use `kubectl apply -f <deployment.yaml>` for full deployment
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successfully completed!"
        }
        failure {
            echo "Build or deployment failed!"
        }
    }
}

