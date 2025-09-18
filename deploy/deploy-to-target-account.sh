#!/bin/bash

# Deploy Dataigloo to specific AWS account: 768472023706
# This script handles deployment to the target AWS account

set -e

# Target account configuration
TARGET_ACCOUNT="768472023706"
STACK_NAME="dataigloo-production"
BUCKET_NAME="dataigloo-production-$(date +%s)"
DOMAIN_NAME="dataigloo.com"
AWS_PROFILE=${AWS_PROFILE:-"target-account"}
AWS_REGION=${AWS_REGION:-"us-east-1"}

echo "🚀 Starting Dataigloo deployment to target account..."
echo "Target Account: $TARGET_ACCOUNT"
echo "Stack Name: $STACK_NAME"
echo "Bucket Name: $BUCKET_NAME"
echo "Domain: $DOMAIN_NAME"
echo "AWS Profile: $AWS_PROFILE"
echo "AWS Region: $AWS_REGION"

# Verify we're deploying to the correct account
echo "🔍 Verifying AWS account..."
CURRENT_ACCOUNT=$(aws sts get-caller-identity --profile $AWS_PROFILE --query 'Account' --output text 2>/dev/null || echo "ERROR")

if [ "$CURRENT_ACCOUNT" != "$TARGET_ACCOUNT" ]; then
    echo "❌ Error: Current AWS account ($CURRENT_ACCOUNT) does not match target account ($TARGET_ACCOUNT)"
    echo ""
    echo "To fix this, you need to:"
    echo "1. Configure AWS credentials for account $TARGET_ACCOUNT"
    echo "2. Set up a profile named 'target-account' or update AWS_PROFILE"
    echo ""
    echo "Example setup:"
    echo "aws configure --profile target-account"
    echo "AWS Access Key ID: [your-access-key-for-$TARGET_ACCOUNT]"
    echo "AWS Secret Access Key: [your-secret-key-for-$TARGET_ACCOUNT]"
    echo "Default region name: $AWS_REGION"
    exit 1
fi

echo "✅ Confirmed deployment to account: $TARGET_ACCOUNT"

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

S3_BUCKET=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`S3BucketName`].OutputValue' \
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
aws s3 sync dist/ s3://$S3_BUCKET \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --delete \
    --cache-control "public, max-age=31536000" \
    --exclude "*.html" \
    --exclude "*.json"

# Upload HTML files with shorter cache control
echo "📤 Uploading HTML files with no-cache..."
aws s3 sync dist/ s3://$S3_BUCKET \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --delete \
    --cache-control "no-cache" \
    --include "*.html" \
    --include "*.json"

# Invalidate CloudFront cache if available
if [ -n "$CLOUDFRONT_ID" ] && [ "$CLOUDFRONT_ID" != "None" ]; then
    echo "🔄 Invalidating CloudFront cache..."
    aws cloudfront create-invalidation \
        --distribution-id $CLOUDFRONT_ID \
        --paths "/*" \
        --profile $AWS_PROFILE
fi

echo "✅ Deployment complete!"
echo ""
echo "🌐 Website URL: $WEBSITE_URL"
echo "🪣 S3 Bucket: $S3_BUCKET"
echo "☁️ CloudFront ID: $CLOUDFRONT_ID"
echo "🎯 AWS Account: $TARGET_ACCOUNT"
echo ""
echo "Note: If using CloudFront, it may take 10-15 minutes to fully deploy."