#!/bin/bash
set -e

echo "===== Lanka MicroJob CD Deployment ====="

AWS_REGION="ap-southeast-2"
IMAGE_TAG=$(cat image-tag.txt)

AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account \
  --output text)

ECR_BASE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Deploying image tag: ${IMAGE_TAG}"

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

kubectl set image deployment/user-service \
  user-service=${ECR_BASE}/lanka-microjob-user-service:${IMAGE_TAG}

kubectl set image deployment/job-service \
  job-service=${ECR_BASE}/lanka-microjob-job-service:${IMAGE_TAG}

kubectl set image deployment/matching-service \
  matching-service=${ECR_BASE}/lanka-microjob-matching-service:${IMAGE_TAG}

kubectl set image deployment/broker-service \
  broker-service=${ECR_BASE}/lanka-microjob-broker-service:${IMAGE_TAG}

kubectl set image deployment/notification-service \
  notification-service=${ECR_BASE}/lanka-microjob-notification-service:${IMAGE_TAG}

kubectl set image deployment/api-gateway \
  api-gateway=${ECR_BASE}/lanka-microjob-api-gateway:${IMAGE_TAG}

kubectl set image deployment/frontend \
  frontend=${ECR_BASE}/lanka-microjob-frontend:${IMAGE_TAG}

kubectl rollout status deployment/user-service --timeout=300s
kubectl rollout status deployment/job-service --timeout=300s
kubectl rollout status deployment/matching-service --timeout=300s
kubectl rollout status deployment/broker-service --timeout=300s
kubectl rollout status deployment/notification-service --timeout=300s
kubectl rollout status deployment/api-gateway --timeout=300s
kubectl rollout status deployment/frontend --timeout=300s

kubectl get pods

echo "===== Deployment completed ====="