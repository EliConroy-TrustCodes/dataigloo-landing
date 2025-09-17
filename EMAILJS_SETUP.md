# EmailJS Setup Guide

## 1. Create EmailJS Account

1. Go to [EmailJS Dashboard](https://dashboard.emailjs.com/)
2. Sign up for a free account
3. Verify your email address

## 2. Set up Email Service

1. Go to **Email Services** in the dashboard
2. Click **Add New Service**
3. Choose your email provider (Gmail, Outlook, etc.)
4. Follow the setup instructions for your provider
5. Note down your **Service ID** (e.g., `service_xxxxxxx`)

## 3. Create Email Template

1. Go to **Email Templates** in the dashboard
2. Click **Create New Template**
3. Use this template structure:

### Template Content:

**Subject:** New Contact Form Submission from {{from_name}}

**Body:**
```
You have received a new message from your website contact form.

From: {{from_name}}
Email: {{from_email}}
Company: {{company}}

Message:
{{message}}

---
This message was sent from the Dataigloo website contact form.
```

4. Save the template and note down your **Template ID** (e.g., `template_xxxxxxx`)

## 4. Get Public Key

1. Go to **Account** → **API Keys**
2. Copy your **Public Key**

## 5. Configure Environment Variables

Create a `.env` file in your project root:

```env
VITE_EMAILJS_SERVICE_ID=your_service_id_here
VITE_EMAILJS_TEMPLATE_ID=your_template_id_here
VITE_EMAILJS_PUBLIC_KEY=your_public_key_here
```

## 6. Template Variables Reference

The contact form sends these variables to your template:

- `{{from_name}}` - Sender's name
- `{{from_email}}` - Sender's email
- `{{company}}` - Sender's company
- `{{message}}` - The message content
- `{{to_email}}` - Your receiving email (hello@dataigloo.nz)

## 7. Testing

1. Start your development server: `npm run dev`
2. Fill out the contact form
3. Check your email inbox for the message
4. Check the browser console for any errors

## 8. Production Setup

For production deployment, add the environment variables to your hosting platform:

### GitHub Actions (already configured)
Add these secrets to your GitHub repository:
- `VITE_EMAILJS_SERVICE_ID`
- `VITE_EMAILJS_TEMPLATE_ID`
- `VITE_EMAILJS_PUBLIC_KEY`

### Vercel
```bash
vercel env add VITE_EMAILJS_SERVICE_ID
vercel env add VITE_EMAILJS_TEMPLATE_ID
vercel env add VITE_EMAILJS_PUBLIC_KEY
```

### Netlify
Add to your `netlify.toml` or via Netlify dashboard.

## 9. Free Tier Limits

EmailJS free tier includes:
- 200 emails per month
- 2 email services
- 1 email template

For higher volume, consider upgrading to a paid plan.

## 10. Security Notes

- The public key is safe to expose in client-side code
- Never expose your private key
- Consider implementing rate limiting for production
- EmailJS includes built-in spam protection

## Troubleshooting

### Common Issues:

1. **403 Forbidden**: Check your public key
2. **Template not found**: Verify template ID
3. **Service not found**: Verify service ID
4. **Network errors**: Check internet connection and EmailJS status

### Debug Steps:

1. Check browser console for errors
2. Verify all environment variables are set
3. Test with a simple template first
4. Check EmailJS dashboard for delivery logs