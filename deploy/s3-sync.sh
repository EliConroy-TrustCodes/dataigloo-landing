#!/bin/bash

# AWS S3 deployment script for Dataigloo Vue app
# Usage: ./deploy/s3-sync.sh [bucket-name] [aws-profile]

set -e

BUCKET_NAME=${1:-"your-dataigloo-bucket"}
AWS_PROFILE=${2:-"default"}
DIST_DIR="dist"

echo "🚀 Deploying Dataigloo Vue app to S3..."
echo "Bucket: $BUCKET_NAME"
echo "Profile: $AWS_PROFILE"
echo "Distribution directory: $DIST_DIR"

# Check if dist directory exists
if [ ! -d "$DIST_DIR" ]; then
    echo "❌ Error: $DIST_DIR directory not found. Run 'npm run build' first."
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Build the project
echo "📦 Building project..."
npm run build

# Sync files to S3
echo "📤 Uploading files to S3..."
aws s3 sync $DIST_DIR/ s3://$BUCKET_NAME \
    --profile $AWS_PROFILE \
    --delete \
    --cache-control "public, max-age=31536000" \
    --exclude "*.html" \
    --exclude "*.json"

# Upload HTML files with shorter cache control
echo "📤 Uploading HTML files with no-cache..."
aws s3 sync $DIST_DIR/ s3://$BUCKET_NAME \
    --profile $AWS_PROFILE \
    --delete \
    --cache-control "no-cache" \
    --include "*.html" \
    --include "*.json"

# Set proper content types
echo "🔧 Setting content types..."
aws s3 cp s3://$BUCKET_NAME/index.html s3://$BUCKET_NAME/index.html \
    --profile $AWS_PROFILE \
    --content-type "text/html; charset=utf-8" \
    --metadata-directive REPLACE \
    --cache-control "no-cache"

echo "✅ Deployment complete!"
echo "🌐 Your site should be available at: https://$BUCKET_NAME.s3-website.amazonaws.com"