# 🚀 Deploy Production-Ready Apps (Without Payment)

## ✅ Ready to Deploy (4 Apps):

**Apply only these ArgoCD applications:**

```bash
# Deploy Dashboard
kubectl apply -f argocd/projects/platform-project.yaml
kubectl apply -f argocd/applications/dashboard-app.yaml

# Deploy Complex
kubectl apply -f argocd/applications/complex-app.yaml

# Deploy UserWebsite  
kubectl apply -f argocd/applications/userwebsite-app.yaml

# Deploy Landing
kubectl apply -f argocd/applications/landing-app.yaml

# Skip payment-app.yaml (don't apply it)
```

## 🚫 Payment App Status:
- **Files exist**: Template files remain in `apps/payment/`
- **Not deployed**: `payment-app.yaml` not applied to ArgoCD
- **No impact**: Other apps work independently
- **Future ready**: Can deploy payment later when YAML is ready

## ✅ Verify Deployments:
```bash
# Check ArgoCD applications
kubectl get applications -n argocd

# Should show: dashboard-dev, dashboard-staging, dashboard-prod, 
#              complex-dev, complex-staging, complex-prod,
#              userwebsite-dev, userwebsite-staging, userwebsite-prod,
#              landing-dev, landing-staging, landing-prod
# (12 total - no payment apps)

# Check running pods
kubectl get pods -n production
kubectl get pods -n staging  
kubectl get pods -n dev
```

## 🌐 Live URLs:
- **Dashboard**: https://dashboard.wolfixor.shop
- **Complex**: https://complex.wolfixor.shop
- **UserWebsite**: https://userwebsite.wolfixor.shop
- **Landing**: https://www.wolfixor.shop

**Payment app stays dormant until you're ready to deploy it!** 💤