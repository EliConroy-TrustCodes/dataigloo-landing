# Domain Setup Guide for dataigloo.com

## 🌐 Overview

Your Dataigloo landing page is now configured to work with the `dataigloo.com` domain. This guide explains how to set up the full domain integration with SSL and DNS.

**Domain Options:**
- **Primary:** `dataigloo.com` (broader international reach)
- **Alternative:** `dataigloo.com` (New Zealand market focus)

## 🏗️ Current Status

✅ **Code configured** - All references to dataigloo.com added
✅ **CloudFormation template** - Supports SSL and Route53 setup
✅ **Environment variables** - Domain configuration ready

## 📋 Domain Setup Options

### Option 1: Simple CloudFront Domain (Current)
Your site is currently running on CloudFront's domain:
- **URL:** https://your-cloudfront-id.cloudfront.net
- **Works immediately** - No domain configuration needed
- **Free SSL** included with CloudFront

### Option 2: Custom Domain with SSL (Recommended)
Set up `dataigloo.com` with proper SSL certificate:

```bash
# Deploy with SSL certificate
aws cloudformation deploy \
  --template-file deploy/cloudformation.yaml \
  --stack-name dataigloo-production \
  --parameter-overrides \
    DomainName=dataigloo.com \
    BucketName=dataigloo-production-$(date +%s) \
    CreateSSLCertificate=true
```

### Option 3: Full Domain Setup with Route53
Complete setup with AWS managing your DNS:

```bash
# Deploy with SSL + Route53
aws cloudformation deploy \
  --template-file deploy/cloudformation.yaml \
  --stack-name dataigloo-production \
  --parameter-overrides \
    DomainName=dataigloo.com \
    BucketName=dataigloo-production-$(date +%s) \
    CreateSSLCertificate=true \
    CreateRoute53Records=true
```

## 🔧 Step-by-Step Domain Setup

### Step 1: Choose Your Option
- **Testing/Demo:** Use current CloudFront URL
- **Production:** Use Option 2 or 3 above

### Step 2: Deploy with Domain
```bash
# Choose your deployment command from above
# Wait for SSL certificate validation (can take 20-30 minutes)
```

### Step 3: Configure DNS (if using your own DNS)

If you're not using Route53, point your domain to CloudFront:

1. **Get CloudFront domain** from CloudFormation outputs:
   ```bash
   aws cloudformation describe-stacks \
     --stack-name dataigloo-production \
     --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontURL`].OutputValue' \
     --output text
   ```

2. **Create CNAME record** in your DNS provider:
   ```
   Type: CNAME
   Name: www.dataigloo.com
   Value: [CloudFront domain from step 1]

   Type: A (Alias if supported)
   Name: dataigloo.com
   Value: [CloudFront domain from step 1]
   ```

### Step 4: Update GitHub Variables (Optional)
Set custom contact information in GitHub repository variables:

```bash
gh variable set DOMAIN_NAME --body "dataigloo.com"
gh variable set SITE_URL --body "https://dataigloo.com"
gh variable set CONTACT_EMAIL --body "hello@dataigloo.com"
gh variable set PHONE_NUMBER --body "+64 (9) 123-4567"
gh variable set LINKEDIN_URL --body "https://www.linkedin.com/company/dataigloo"
```

## 🎯 Production Deployment

For production with custom domain:

```bash
# 1. Deploy infrastructure with domain
./deploy/deploy.sh

# 2. Update package.json deploy script
npm run deploy

# 3. Set up automatic deployments via GitHub Actions
# (Already configured - just push to main branch)
```

## 🔍 Verification

Check your domain setup:

```bash
# Test SSL certificate
curl -I https://dataigloo.com

# Check DNS resolution
nslookup dataigloo.com

# Verify redirects
curl -I http://dataigloo.com  # Should redirect to https
curl -I https://www.dataigloo.com  # Should work
```

## 📊 CloudFormation Outputs

After deployment, get important values:

```bash
# Website URL
aws cloudformation describe-stacks \
  --stack-name dataigloo-production \
  --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
  --output text

# Name servers (if using Route53)
aws cloudformation describe-stacks \
  --stack-name dataigloo-production \
  --query 'Stacks[0].Outputs[?OutputKey==`NameServers`].OutputValue' \
  --output text
```

## 🚨 Important Notes

### SSL Certificate Validation
- DNS validation can take 20-30 minutes
- Check ACM console for validation status
- Must be deployed in `us-east-1` region for CloudFront

### Route53 Costs
- Hosted zone: $0.50/month per domain
- DNS queries: $0.40 per million queries
- Consider if you need AWS to manage DNS

### Domain Ownership
- You must own `dataigloo.com` domain
- Register through AWS Route53 or external provider
- Point name servers to AWS if using Route53

## 🔄 Migration from Current Setup

If you want to migrate from the current S3 setup to custom domain:

1. **Keep current site running** while setting up new infrastructure
2. **Deploy new stack** with domain configuration
3. **Test thoroughly** before switching DNS
4. **Update DNS** to point to new CloudFront distribution
5. **Monitor** for any issues

## 📞 Support

- **AWS Documentation:** [Custom Origins with CloudFront](https://docs.aws.amazon.com/cloudfront/latest/developerguide/CNAMEs.html)
- **Route53 Guide:** [Getting Started with Route53](https://docs.aws.amazon.com/route53/latest/developerguide/getting-started.html)
- **SSL Certificate:** [Request ACM Certificate](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)