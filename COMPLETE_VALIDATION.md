# 🔍 Complete YAML Validation Checklist

## 📋 Other Parts to Validate

### **1. Image and Registry Access**
```yaml
image: wolfix1245/dashboard:1.1
imagePullPolicy: IfNotPresent
```

**Test commands:**
```bash
# Check if image exists and is accessible
kubectl run test-image --image=wolfix1245/dashboard:1.1 --dry-run=client -o yaml

# Test image pull
kubectl run test-pull --image=wolfix1245/dashboard:1.1 --rm -it --restart=Never -- echo "Image works"
```

**Image Pull Policies:**
- `Always`: Pull image every time
- `IfNotPresent`: Pull only if not cached locally
- `Never`: Only use local cache

### **2. Container Ports**
```yaml
ports:
  - containerPort: 3000
    name: http
    protocol: TCP
```

**Validation:**
```bash
# Check if your app actually listens on port 3000
# Test after deployment:
kubectl port-forward pod/<pod-name> 8080:3000
# Then visit http://localhost:8080
```

### **3. Environment Variables from Secrets**
```yaml
env:
  - name: JWT_SECRET
    valueFrom:
      secretKeyRef:
        name: shared-secret
        key: JWT_SECRET
```

**Test commands:**
```bash
# Check if secrets exist
kubectl get secrets -n production
kubectl get secrets -n staging  
kubectl get secrets -n dev

# Check secret contents (keys only, not values)
kubectl describe secret shared-secret -n production

# Test if all required keys exist
kubectl get secret shared-secret -n production -o jsonpath='{.data}' | jq 'keys'
```

### **4. Service Configuration**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: dashboard-app
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 3000
```

**Validation:**
```bash
# After deployment, test service
kubectl get svc -n production
kubectl describe svc dashboard-app -n production

# Test service connectivity
kubectl run test-svc --image=busybox --rm -it -- wget -qO- http://dashboard-app.production.svc.cluster.local
```

### **5. Ingress Configuration**
```yaml
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - dashboard.wolfixor.shop
    secretName: dashboard-tls
```

**Test commands:**
```bash
# Check if nginx ingress controller exists
kubectl get pods -A | grep nginx
kubectl get ingressclass

# Check if cert-manager is installed (for TLS)
kubectl get pods -n cert-manager

# After deployment, check ingress
kubectl get ingress -n production
kubectl describe ingress dashboard-ingress -n production
```

### **6. HPA (Horizontal Pod Autoscaler)**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

**Test commands:**
```bash
# Check if metrics server is installed
kubectl get pods -n kube-system | grep metrics-server

# After deployment, check HPA
kubectl get hpa -n production
kubectl describe hpa dashboard-app -n production

# Check current resource usage
kubectl top pods -n production
```

## 🚨 Common Issues to Check

### **1. Missing Metrics Server**
If HPA doesn't work:
```bash
# Install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### **2. Missing Ingress Controller**
If ingress doesn't work:
```bash
# Install nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

### **3. Missing Cert-Manager**
If SSL doesn't work:
```bash
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

### **4. DNS Issues**
Test cluster DNS:
```bash
kubectl run test-dns --image=busybox --rm -it -- nslookup kubernetes.default.svc.cluster.local
```

## ✅ Complete Validation Workflow

**1. Pre-deployment validation:**
```bash
# Test YAML syntax
kubectl apply --dry-run=client -f apps/dashboard/base/

# Test against cluster
kubectl apply --dry-run=server -f apps/dashboard/base/

# Test kustomization
kustomize build apps/dashboard/overlays/prod | kubectl apply --dry-run=server -f -
```

**2. Check dependencies:**
```bash
kubectl get ns production staging dev
kubectl get secrets shared-secret -n production
kubectl get pods -A | grep -E "(nginx|cert-manager|metrics)"
```

**3. Deploy and verify:**
```bash
# Deploy
kubectl apply -f argocd/applications/dashboard-app.yaml

# Check status
kubectl get pods -n production -l app=dashboard-app
kubectl get svc -n production
kubectl get ingress -n production
kubectl get hpa -n production
```

**4. Test functionality:**
```bash
# Test internal connectivity
kubectl port-forward svc/dashboard-app 8080:80 -n production

# Test external access (after DNS setup)
curl -k https://dashboard.wolfixor.shop
```

This comprehensive validation ensures every part of your YAML works correctly with your cluster! 🎯