#!/bin/bash

SERVICE_ACCOUNT_NAME=aws-load-balancer-controller
POLICY_NAME=AWSLoadBalancerControllerIAMPolicy
ROLE_NAME=AmazonEKSLoadBalancerControllerRole
ACCOUNT_ID=767397983464
POLICY_ARN=arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME
NAMESPACE=dev
REGION=ap-south-1
VPC_ID=vpc-01612e4d281af91c4
CLUSTER_NAME=yaara

echo "Downloading IAM policy JSON..."
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json && # Download the IAM policy JSON

echo "Creating IAM policy..."
aws iam create-policy --policy-name $POLICY_NAME --policy-document file://iam_policy.json && # Create IAM policy

# Check if the policy creation failed
if [ $? -ne 0 ]; then
    echo "Policy already exists, continuing with the script."
else
    echo "Policy created successfully."
fi

echo "Creating IAM service account..."
eksctl create iamserviceaccount --cluster=$CLUSTER_NAME --namespace=$NAMESPACE --name=$SERVICE_ACCOUNT_NAME --role-name $ROLE_NAME --attach-policy-arn=$POLICY_ARN --approve && # Create IAM service account

echo "Adding and updating Helm repo..."
helm repo add eks https://aws.github.io/eks-charts && # Add and update Helm repo
helm repo update eks && # Updating Helm repo

echo "Installing AWS Load Balancer Controller..."
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n $NAMESPACE --set clusterName=$CLUSTER_NAME --set serviceAccount.create=false --set serviceAccount.name=$SERVICE_ACCOUNT_NAME --set region=$REGION --set vpcId=$VPC_ID && # Install AWS Load Balancer Controller

echo "Checking deployment status..."
kubectl get deployment -n $NAMESPACE $SERVICE_ACCOUNT_NAME && # Get deployment status

echo "Wait for the ingress controller pods to be created and then run this command to get alb url: kubectl get ingress -n <namespace>"
echo "Script execution complete."
