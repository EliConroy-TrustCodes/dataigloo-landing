# GitHub Actions Setup Guide

## Required Repository Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

### Secrets
Add these secrets:

```
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

### Variables
Add these repository variables:

```
S3_BUCKET_NAME=your-production-bucket-name
AWS_REGION=us-east-1
CLOUDFRONT_DISTRIBUTION_ID=your_cloudfront_id (optional)
```

## Setting up AWS Credentials

### Option 1: IAM User (Recommended for testing)

1. Create an IAM user in AWS Console
2. Attach these policies:
   - `AmazonS3FullAccess`
   - `CloudFrontFullAccess` (if using CloudFront)

3. Generate Access Keys and add to GitHub Secrets

### Option 2: IAM Role with OIDC (Production recommended)

More secure option - see GitHub's documentation on configuring OpenID Connect.

## Bucket Setup

### For Production
Use the CloudFormation template in `/deploy/cloudformation.yaml` to create:
- S3 bucket with website hosting
- CloudFront distribution (optional)
- Proper IAM policies

```bash
aws cloudformation deploy \
  --template-file deploy/cloudformation.yaml \
  --stack-name dataigloo-production \
  --parameter-overrides \
    DomainName=dataigloo.nz \
    BucketName=dataigloo-production-static
```

### For Simple S3 Hosting
```bash
# Create bucket
aws s3 mb s3://your-bucket-name

# Enable website hosting
aws s3 website s3://your-bucket-name \
  --index-document index.html \
  --error-document index.html

# Set public access (be careful!)
aws s3api put-public-access-block \
  --bucket your-bucket-name \
  --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Set bucket policy
aws s3api put-bucket-policy --bucket your-bucket-name --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}'
```

## Workflow Features

### Main Deployment (`deploy.yml`)
- Triggers on push to `main`/`master`
- Builds and deploys to production S3 bucket
- Invalidates CloudFront cache (if configured)

### Preview Deployments (`preview.yml`)
- Triggers on Pull Requests
- Creates temporary S3 bucket for preview
- Comments on PR with preview URL

### Preview Cleanup (`cleanup-preview.yml`)
- Triggers when PR is closed
- Automatically deletes preview buckets
- Keeps AWS costs low

## Manual Deployment

You can still deploy manually using:

```bash
# Build and deploy
npm run build
./deploy/deploy.sh

# Or just sync to S3
./deploy/s3-sync.sh your-bucket-name
```

## Troubleshooting

### Permission Errors
- Check IAM policies are attached
- Verify AWS credentials are correct
- Ensure bucket names are unique globally

### Build Failures
- Check Node.js version (should be 18+)
- Clear cache: `rm -rf node_modules package-lock.json && npm install`

### Preview URLs Not Working
- Check bucket policy allows public access
- Verify website hosting is enabled
- Wait a few seconds for DNS propagation