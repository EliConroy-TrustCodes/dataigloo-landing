# Deploy to AWS Account 768472023706

## 🎯 Target Account Setup

**Target AWS Account:** `768472023706`
**Deployment Script:** `./deploy/deploy-to-target-account.sh`

## 🔧 Prerequisites

You need AWS credentials for account `768472023706`. Here's how to set them up:

### Option 1: AWS Configure (Recommended)

```bash
# Set up a new profile for the target account
aws configure --profile target-account

# When prompted, enter:
AWS Access Key ID: [your-access-key-for-768472023706]
AWS Secret Access Key: [your-secret-key-for-768472023706]
Default region name: us-east-1
Default output format: json
```

### Option 2: Environment Variables

```bash
export AWS_ACCESS_KEY_ID=your-access-key-for-768472023706
export AWS_SECRET_ACCESS_KEY=your-secret-key-for-768472023706
export AWS_DEFAULT_REGION=us-east-1
export AWS_PROFILE=target-account
```

### Option 3: Update Existing Profile

```bash
# If you want to use your default profile
aws configure set aws_access_key_id your-access-key-for-768472023706
aws configure set aws_secret_access_key your-secret-key-for-768472023706
aws configure set region us-east-1
```

## 🚀 Deployment Steps

### 1. Verify Account Access

```bash
# Test access to target account
aws sts get-caller-identity --profile target-account
```

Expected output:
```json
{
    "UserId": "...",
    "Account": "768472023706",
    "Arn": "arn:aws:iam::768472023706:user/..."
}
```

### 2. Run Deployment

```bash
# Deploy to target account
./deploy/deploy-to-target-account.sh
```

### 3. Alternative with Custom Profile

```bash
# If using a different profile name
AWS_PROFILE=your-profile-name ./deploy/deploy-to-target-account.sh
```

## 📋 What Gets Deployed

**Infrastructure:**
- S3 bucket for static website hosting
- CloudFront distribution (optional)
- IAM policies for bucket access

**Application:**
- Vue.js Dataigloo landing page
- Contact form with EmailJS integration
- Domain configured for dataigloo.com
- Responsive design and SEO optimization

## 🌐 Expected Outputs

After successful deployment:

```
✅ Deployment complete!

🌐 Website URL: https://your-cloudfront-id.cloudfront.net
🪣 S3 Bucket: dataigloo-production-1234567890
☁️ CloudFront ID: ABCD123456789
🎯 AWS Account: 768472023706
```

## 🔧 Troubleshooting

### Access Denied Errors

If you get permission errors, ensure your IAM user has these policies:
- `AmazonS3FullAccess`
- `CloudFrontFullAccess`
- `AWSCloudFormationFullAccess`

### Wrong Account Error

If the script shows wrong account, verify:
```bash
aws sts get-caller-identity --profile target-account
```

### Profile Not Found

Create the profile:
```bash
aws configure --profile target-account
```

## 🔄 GitHub Actions Update

To update GitHub Actions for the new account:

```bash
# Get the new access keys for account 768472023706
# Then update GitHub secrets:
gh secret set AWS_ACCESS_KEY_ID --body "your-new-access-key"
gh secret set AWS_SECRET_ACCESS_KEY --body "your-new-secret-key"

# Update variables if needed
gh variable set S3_BUCKET_NAME --body "your-new-bucket-name"
```

## 🎯 Next Steps

1. **Get AWS credentials** for account `768472023706`
2. **Configure AWS profile** using the steps above
3. **Run deployment script**: `./deploy/deploy-to-target-account.sh`
4. **Update GitHub Actions** with new credentials
5. **Test the deployed site**

The script will automatically verify you're deploying to the correct account before proceeding.