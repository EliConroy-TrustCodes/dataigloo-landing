#!/bin/bash

# Quick deployment to AWS Account 768472023706
# Run this after setting up your AWS credentials

set -e

TARGET_ACCOUNT="768472023706"
BUCKET_NAME="dataigloo-$(date +%s)"
REGION="us-east-1"

echo "🚀 Quick Deploy to Account $TARGET_ACCOUNT"
echo "Creating bucket: $BUCKET_NAME"

# Verify account
CURRENT_ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)
if [ "$CURRENT_ACCOUNT" != "$TARGET_ACCOUNT" ]; then
    echo "❌ Wrong account! Current: $CURRENT_ACCOUNT, Expected: $TARGET_ACCOUNT"
    echo "Run: aws configure --profile target-account"
    echo "Then: AWS_PROFILE=target-account $0"
    exit 1
fi

echo "✅ Confirmed account: $TARGET_ACCOUNT"

# Build if needed
if [ ! -d "dist" ]; then
    echo "📦 Building project..."
    npm run build
fi

# Create and configure S3 bucket
echo "🪣 Creating S3 bucket..."
aws s3 mb s3://$BUCKET_NAME --region $REGION

echo "🌐 Enabling website hosting..."
aws s3 website s3://$BUCKET_NAME --index-document index.html --error-document index.html

echo "🔓 Setting public access..."
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

echo "📋 Setting bucket policy..."
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
    }
  ]
}'

echo "📤 Uploading files..."
aws s3 sync dist/ s3://$BUCKET_NAME --delete

# Generate URLs
if [ "$REGION" = "us-east-1" ]; then
    WEBSITE_URL="http://$BUCKET_NAME.s3-website.amazonaws.com"
else
    WEBSITE_URL="http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
fi

echo ""
echo "✅ Deployment Complete!"
echo "🌐 Website URL: $WEBSITE_URL"
echo "🪣 S3 Bucket: $BUCKET_NAME"
echo "🎯 AWS Account: $TARGET_ACCOUNT"
echo "📍 Region: $REGION"
echo ""
echo "🔗 Test your site: $WEBSITE_URL"