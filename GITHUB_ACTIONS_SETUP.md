# GitHub Actions Setup Guide

## 🔐 Required Secrets & Variables

### 1. AWS Secrets
Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions**

#### Add these Repository Secrets:
```
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

#### Add these Repository Variables:
```
S3_BUCKET_NAME=your-production-bucket-name
AWS_REGION=us-east-1
CLOUDFRONT_DISTRIBUTION_ID=your_cloudfront_id (optional)
```

### 2. EmailJS Secrets
Add these Repository Secrets for EmailJS:
```
VITE_EMAILJS_SERVICE_ID=your_service_id
VITE_EMAILJS_TEMPLATE_ID=your_template_id
VITE_EMAILJS_PUBLIC_KEY=your_public_key
```

## 🛠 AWS Setup

### Option 1: Create IAM User (Quick Setup)

1. **Create IAM User:**
   ```bash
   aws iam create-user --user-name dataigloo-github-actions
   ```

2. **Attach Policies:**
   ```bash
   aws iam attach-user-policy --user-name dataigloo-github-actions --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
   aws iam attach-user-policy --user-name dataigloo-github-actions --policy-arn arn:aws:iam::aws:policy/CloudFrontFullAccess
   ```

3. **Create Access Keys:**
   ```bash
   aws iam create-access-key --user-name dataigloo-github-actions
   ```

### Option 2: Use CloudFormation (Recommended)

Deploy the infrastructure first:

```bash
aws cloudformation deploy \
  --template-file deploy/cloudformation.yaml \
  --stack-name dataigloo-production \
  --parameter-overrides \
    DomainName=dataigloo.nz \
    BucketName=dataigloo-production-$(date +%s)
```

## 📧 EmailJS Setup

1. **Create Account:** Go to [EmailJS Dashboard](https://dashboard.emailjs.com/)

2. **Add Email Service:**
   - Choose Gmail/Outlook/etc.
   - Note the **Service ID**

3. **Create Template:**
   - Subject: `New Contact Form Submission from {{from_name}}`
   - Body:
   ```
   From: {{from_name}} ({{from_email}})
   Company: {{company}}

   Message:
   {{message}}
   ```
   - Note the **Template ID**

4. **Get Public Key:**
   - Account → API Keys
   - Copy **Public Key**

## 🚀 Workflow Features

### Main Deployment
- **Trigger:** Push to `main` branch
- **Actions:** Build → Deploy to S3 → Invalidate CloudFront

### Preview Deployments
- **Trigger:** Pull Requests
- **Actions:** Build → Deploy to temporary S3 bucket → Comment PR with URL

### Cleanup
- **Trigger:** PR closed
- **Actions:** Delete temporary buckets

## 🔧 Environment Variables in Workflows

The workflows automatically inject environment variables:

```yaml
env:
  VITE_EMAILJS_SERVICE_ID: ${{ secrets.VITE_EMAILJS_SERVICE_ID }}
  VITE_EMAILJS_TEMPLATE_ID: ${{ secrets.VITE_EMAILJS_TEMPLATE_ID }}
  VITE_EMAILJS_PUBLIC_KEY: ${{ secrets.VITE_EMAILJS_PUBLIC_KEY }}
```

## 🧪 Testing

1. **Push to main:** Should trigger production deployment
2. **Create PR:** Should create preview deployment
3. **Close PR:** Should cleanup preview resources

## 📊 Monitoring

Check workflow status:
- GitHub → Actions tab
- AWS CloudWatch logs
- S3 bucket contents

## 🆘 Troubleshooting

### Common Issues:

1. **AWS Permission Denied:**
   - Check IAM policies are attached
   - Verify access keys are correct

2. **S3 Bucket Already Exists:**
   - Bucket names must be globally unique
   - Use timestamp suffix in bucket name

3. **EmailJS Not Working:**
   - Check all three secrets are set
   - Verify EmailJS template variables match

4. **CloudFront Not Invalidating:**
   - Check CLOUDFRONT_DISTRIBUTION_ID variable
   - Verify CloudFront permissions

### Debug Steps:

1. Check GitHub Actions logs
2. Verify all secrets/variables are set
3. Test AWS credentials locally:
   ```bash
   aws sts get-caller-identity
   ```

## 🔄 Manual Deployment

If GitHub Actions aren't working, deploy manually:

```bash
# Set environment variables
export VITE_EMAILJS_SERVICE_ID="your_service_id"
export VITE_EMAILJS_TEMPLATE_ID="your_template_id"
export VITE_EMAILJS_PUBLIC_KEY="your_public_key"

# Build and deploy
npm run build
./deploy/deploy.sh
```

## 🌍 Custom Domain Setup

1. **Route 53 (Recommended):**
   ```bash
   aws route53 create-hosted-zone --name dataigloo.nz
   # Point A record to CloudFront distribution
   ```

2. **SSL Certificate:**
   ```bash
   aws acm request-certificate --domain-name dataigloo.nz
   # Add to CloudFront distribution
   ```

## 💰 Cost Optimization

- Preview deployments auto-cleanup
- CloudFront caching reduces S3 requests
- Small static site = minimal costs

Estimated monthly cost: $1-5 USD for low-traffic site.