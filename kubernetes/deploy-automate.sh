#!/bin/bash

CLUSTER_NAME=yaara
REGION=ap-south-1
FARGATE_PROFILE=yaara-fp
NAMESPACE=dev

echo "Creating EKS cluster..."
eksctl create cluster --name $CLUSTER_NAME --region $REGION --fargate && # create cluster

echo "Updating kubeconfig..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION && # update kubeconfig

echo "Creating Fargate profile..."
eksctl create fargateprofile --cluster $CLUSTER_NAME --region $REGION --name $FARGATE_PROFILE --namespace $NAMESPACE && # create fargate profile

echo "Deploying manifests..."
kubectl apply -f ./manifests/. && # deploy maifests

echo "Associating IAM OIDC provider..."
eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve 

echo "Deployment complete."
