# Dataigloo Vue Landing Page

A modern, responsive landing page for Dataigloo built with Vue 3, Vite, and Tailwind CSS.

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- npm or yarn
- AWS CLI (for deployment)

### Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📦 Project Structure

```
dataigloo-vue/
├── src/
│   ├── components/
│   │   ├── Logo.vue
│   │   └── UI.vue
│   ├── App.vue
│   ├── main.js
│   └── style.css
├── deploy/
│   ├── cloudformation.yaml
│   ├── deploy.sh
│   └── s3-sync.sh
├── public/
├── index.html
└── package.json
```

## 🛠 Tech Stack

- **Vue 3** - Progressive JavaScript framework
- **Vite** - Fast build tool and dev server
- **Tailwind CSS** - Utility-first CSS framework
- **@vueuse/motion** - Vue animation library (replaces Framer Motion)
- **Lucide Vue** - Beautiful icons

## 🌊 AWS Deployment

### Option 1: Quick Deployment (Recommended)

```bash
# Deploy everything (CloudFormation + S3 sync)
./deploy/deploy.sh
```

### Option 2: Manual Steps

1. **Create infrastructure:**
```bash
aws cloudformation deploy \
    --template-file deploy/cloudformation.yaml \
    --stack-name dataigloo-static-site \
    --parameter-overrides \
        DomainName=dataigloo.nz \
        BucketName=your-unique-bucket-name \
    --capabilities CAPABILITY_IAM
```

2. **Deploy site:**
```bash
npm run build
./deploy/s3-sync.sh your-bucket-name
```

### Option 3: Simple S3 Hosting

```bash
# Just sync to existing S3 bucket
npm run build
aws s3 sync dist/ s3://your-bucket-name --delete
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file for local development:

```env
VITE_CONTACT_EMAIL=hello@dataigloo.nz
VITE_PHONE_NUMBER=+64 (0) ...
VITE_LINKEDIN_URL=https://www.linkedin.com/company/dataigloo
```

### AWS Configuration

Set up your AWS credentials:

```bash
# Configure AWS CLI
aws configure

# Or use environment variables
export AWS_PROFILE=your-profile
export AWS_REGION=us-east-1
```

## 📋 Deployment Checklist

- [ ] Update domain name in `deploy/cloudformation.yaml`
- [ ] Configure AWS credentials
- [ ] Update contact information in `src/App.vue`
- [ ] Replace placeholder logo in `src/components/Logo.vue`
- [ ] Test build locally: `npm run build && npm run preview`
- [ ] Deploy: `./deploy/deploy.sh`

## 🎨 Customization

### Brand Colors

Update brand colors in `src/App.vue`:

```javascript
const brand = {
  bg: "#0B0C0E",      // Background
  ink: "#F4F4F5",     // Primary text
  mute: "#A1A1AA",    // Muted text
  line: "rgba(255,255,255,0.12)", // Borders
  accent: "#8AB4FF",  // Accent color
}
```

### Content

Edit content directly in `src/App.vue` in the data arrays:
- `whyItems` - Benefits list
- `benefits` - Benefits section
- `architectureLeft` / `architectureRight` - Architecture details

## 🚨 Important Notes

### S3 Bucket Names
- S3 bucket names must be globally unique
- The deployment script adds a timestamp suffix
- Update the bucket name in your DNS settings after deployment

### CloudFront
- CloudFront distributions take 10-15 minutes to deploy
- Cache invalidation may take additional time
- HTML files are served with no-cache headers for instant updates

### Domain Setup
- Update DNS records to point to CloudFront distribution
- Consider using Route 53 for easier AWS integration
- SSL certificates are automatically provided by CloudFront

## 🔒 Security

- All files are served over HTTPS
- S3 bucket has read-only public access
- CloudFront provides DDoS protection
- No sensitive data is included in the client bundle

## 📊 Performance

- Vite provides fast HMR during development
- Built files are optimized and minified
- Images and assets are automatically optimized
- CloudFront provides global CDN distribution

## 🐛 Troubleshooting

### Build Issues
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Deployment Issues
```bash
# Check AWS credentials
aws sts get-caller-identity

# Validate CloudFormation template
aws cloudformation validate-template --template-body file://deploy/cloudformation.yaml
```

### Development Issues
```bash
# Clear Vite cache
rm -rf node_modules/.vite
npm run dev
```

## 📝 License

Private - Dataigloo Ltd.

---
🚀 **Status:** Production ready with EmailJS integration and full CI/CD pipeline