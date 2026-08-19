pipeline {
    agent any

    environment {
        STAGING_NAMESPACE = 'kijani-staging'
        PRODUCTION_NAMESPACE = 'kijani-project'
        APP_NAME = 'kk-payments'
        IMAGE = 'kijanikiosk/kk-payments:v1.1.0'
        KUBECONFIG = '/tmp/jenkins-config'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Tools') {
            steps {
                sh '''
                    set -e
                    kubectl version --client
                    kubectl config current-context
                    test -x scripts/smoke-test.sh
                    echo "✓ Required tools available"
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh '''
                    set -e

                    kubectl apply \
                      -f k8s/kk-payments-deployment-staging.yaml \
                      -f k8s/kk-payments-service-staging.yaml
                '''
            }
        }

        stage('Staging Rollout') {
            steps {
                sh '''
                    set -e

                    kubectl rollout status \
                      deployment/${APP_NAME} \
                      -n ${STAGING_NAMESPACE} \
                      --timeout=120s
                '''
            }
        }

        stage('Staging Smoke Test') {
            steps {
                sh '''
                    set -e

                    NAMESPACE=${STAGING_NAMESPACE} \
                    SERVICE=${APP_NAME} \
                    ./scripts/smoke-test.sh
                '''
            }
        }

        stage('Production Approval') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: 'Staging validation passed. Promote kk-payments to production?',
                          ok: 'Promote to Production'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sh '''
                    set -e

                    kubectl set image \
                      deployment/${APP_NAME} \
                      ${APP_NAME}=${IMAGE} \
                      -n ${PRODUCTION_NAMESPACE}
                '''
            }
        }

        stage('Production Rollout') {
            steps {
                sh '''
                    set -e

                    kubectl rollout status \
                      deployment/${APP_NAME} \
                      -n ${PRODUCTION_NAMESPACE} \
                      --timeout=120s
                '''
            }
        }
    }

    post {
        success {
            echo 'KijaniKiosk deployment pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Production promotion was not completed.'
        }

        aborted {
            echo 'Pipeline was aborted.'
        }
    }
}
