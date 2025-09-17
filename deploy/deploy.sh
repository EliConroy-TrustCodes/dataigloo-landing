#!/bin/bash

# Complete deployment script for Dataigloo Vue app
# This script handles CloudFormation stack creation and S3 deployment

set -e

# Configuration
STACK_NAME="dataigloo-static-site"
BUCKET_NAME="dataigloo-static-site-$(date +%s)"  # Unique bucket name
DOMAIN_NAME="dataigloo.nz"
AWS_PROFILE=${AWS_PROFILE:-"default"}
AWS_REGION=${AWS_REGION:-"us-east-1"}

echo "🚀 Starting Dataigloo deployment..."
echo "Stack Name: $STACK_NAME"
echo "Bucket Name: $BUCKET_NAME"
echo "Domain: $DOMAIN_NAME"
echo "AWS Profile: $AWS_PROFILE"
echo "AWS Region: $AWS_REGION"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Build the project
echo "📦 Building project..."
npm run build

# Deploy CloudFormation stack
echo "☁️ Deploying CloudFormation stack..."
aws cloudformation deploy \
    --template-file deploy/cloudformation.yaml \
    --stack-name $STACK_NAME \
    --parameter-overrides \
        DomainName=$DOMAIN_NAME \
        BucketName=$BUCKET_NAME \
    --capabilities CAPABILITY_IAM \
    --profile $AWS_PROFILE \
    --region $AWS_REGION

# Get stack outputs
echo "📋 Getting stack outputs..."
WEBSITE_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

CLOUDFRONT_ID=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

# Sync files to S3
echo "📤 Uploading files to S3..."
aws s3 sync dist/ s3://$BUCKET_NAME \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --delete \
    --cache-control "public, max-age=31536000" \
    --exclude "*.html" \
    --exclude "*.json"

# Upload HTML files with shorter cache control
echo "📤 Uploading HTML files with no-cache..."
aws s3 sync dist/ s3://$BUCKET_NAME \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --delete \
    --cache-control "no-cache" \
    --include "*.html" \
    --include "*.json"

# Invalidate CloudFront cache
echo "🔄 Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
    --distribution-id $CLOUDFRONT_ID \
    --paths "/*" \
    --profile $AWS_PROFILE

echo "✅ Deployment complete!"
echo ""
echo "🌐 Website URL: $WEBSITE_URL"
echo "🪣 S3 Bucket: $BUCKET_NAME"
echo "☁️ CloudFront ID: $CLOUDFRONT_ID"
echo ""
echo "Note: CloudFront distribution may take 10-15 minutes to fully deploy."