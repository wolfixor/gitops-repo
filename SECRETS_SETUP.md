# Dashboard Secrets Setup Guide

## 🔐 Required Secrets

Your dashboard application requires the `shared-secret` in each namespace. Create these secrets before deploying:

### **Production Environment**
```bash
kubectl create secret generic shared-secret \
  --namespace=production \
  --from-literal=JWT_SECRET="your-production-jwt-secret" \
  --from-literal=MONGODB_URI="your-production-mongodb-uri" \
  --from-literal=ZARINPAL_MERCHANT_ID="your-zarinpal-merchant-id" \
  --from-literal=ARVAN_API_TOKEN="your-arvan-api-token" \
  --from-literal=SMS_IR_LINE_NUMBER="your-sms-line-number" \
  --from-literal=SMS_IR_TEMPLATE_ID="your-sms-template-id" \
  --from-literal=SMS_IR_API_KEY="your-sms-api-key" \
  --from-literal=NAMESPACE="production" \
  --from-literal=ARVAN_ACCESS_KEY="your-arvan-access-key" \
  --from-literal=ARVAN_SECRET_KEY="your-arvan-secret-key" \
  --from-literal=ARVAN_BUCKET_NAME="your-production-bucket"
```

### **Staging Environment**
```bash
kubectl create secret generic shared-secret \
  --namespace=staging \
  --from-literal=JWT_SECRET="your-staging-jwt-secret" \
  --from-literal=MONGODB_URI="your-staging-mongodb-uri" \
  --from-literal=ZARINPAL_MERCHANT_ID="your-zarinpal-merchant-id" \
  --from-literal=ARVAN_API_TOKEN="your-arvan-api-token" \
  --from-literal=SMS_IR_LINE_NUMBER="your-sms-line-number" \
  --from-literal=SMS_IR_TEMPLATE_ID="your-sms-template-id" \
  --from-literal=SMS_IR_API_KEY="your-sms-api-key" \
  --from-literal=NAMESPACE="staging" \
  --from-literal=ARVAN_ACCESS_KEY="your-arvan-access-key" \
  --from-literal=ARVAN_SECRET_KEY="your-arvan-secret-key" \
  --from-literal=ARVAN_BUCKET_NAME="your-staging-bucket"
```

### **Development Environment**
```bash
kubectl create secret generic shared-secret \
  --namespace=dev \
  --from-literal=JWT_SECRET="your-dev-jwt-secret" \
  --from-literal=MONGODB_URI="your-dev-mongodb-uri" \
  --from-literal=ZARINPAL_MERCHANT_ID="your-zarinpal-merchant-id" \
  --from-literal=ARVAN_API_TOKEN="your-arvan-api-token" \
  --from-literal=SMS_IR_LINE_NUMBER="your-sms-line-number" \
  --from-literal=SMS_IR_TEMPLATE_ID="your-sms-template-id" \
  --from-literal=SMS_IR_API_KEY="your-sms-api-key" \
  --from-literal=NAMESPACE="dev" \
  --from-literal=ARVAN_ACCESS_KEY="your-arvan-access-key" \
  --from-literal=ARVAN_SECRET_KEY="your-arvan-secret-key" \
  --from-literal=ARVAN_BUCKET_NAME="your-dev-bucket"
```

## 🔍 Verify Secrets
```bash
# Check if secrets exist
kubectl get secrets -n production
kubectl get secrets -n staging  
kubectl get secrets -n dev

# View secret details (without values)
kubectl describe secret shared-secret -n production
```

## 🚀 Deploy Dashboard
After creating secrets, deploy the dashboard:

```bash
# Apply ArgoCD applications
kubectl apply -f argocd/applications/dashboard-app.yaml

# Check deployment status
kubectl get pods -n production -l app=dashboard-app
kubectl get pods -n staging -l app=dashboard-app
kubectl get pods -n dev -l app=dashboard-app
```

## 🌐 Access URLs
- **Production**: https://dashboard.tomakdigitalagency.ir
- **Staging**: https://dashboard-staging.tomakdigitalagency.ir  
- **Development**: https://dashboarddev.tomakdigitalagency.ir

## ⚠️ Security Notes
- **Never commit secrets** to Git repositories
- **Use different values** for each environment
- **Rotate secrets regularly**
- **Use Kubernetes RBAC** to limit secret access