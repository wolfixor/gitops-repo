# SSL/TLS Setup with Let's Encrypt

## 🔐 All Ingresses Updated with SSL/TLS

### **Certificate Manager Setup Required:**

**1. Install cert-manager:**
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

**2. Create Let's Encrypt ClusterIssuer:**
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@wolfixor.shop
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

**Apply the ClusterIssuer:**
```bash
kubectl apply -f letsencrypt-clusterissuer.yaml
```

### **SSL-Enabled Domains:**

**Dashboard:**
- **Production**: https://dashboard.wolfixor.shop
- **Staging**: https://dashboard-staging.wolfixor.shop  
- **Development**: https://dashboarddev.wolfixor.shop

**Landing:**
- **Production**: https://www.wolfixor.shop
- **Staging**: https://staging.wolfixor.shop
- **Development**: https://dev.wolfixor.shop

### **Features Added:**
- ✅ **Let's Encrypt certificates** for all domains
- ✅ **Automatic SSL redirect** (HTTP → HTTPS)
- ✅ **Force SSL redirect** enabled
- ✅ **Unique TLS secrets** per environment

### **Verify SSL Certificates:**
```bash
# Check certificate status
kubectl get certificates -A

# Check certificate details
kubectl describe certificate dashboard-tls -n production
kubectl describe certificate landing-tls -n production

# Check if secrets are created
kubectl get secrets -A | grep tls
```

### **Certificate Renewal:**
Certificates automatically renew before expiration (Let's Encrypt handles this).

**All ingresses now have production-ready SSL/TLS with Let's Encrypt!** 🔒