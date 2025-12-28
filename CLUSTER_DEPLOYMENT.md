# GitOps Deployment for Your Cluster

## ✅ Updated for Your Cluster Configuration

### **Cluster Details Detected:**
- ✅ **ArgoCD**: Already installed in `argocd` namespace
- ✅ **Namespaces**: Using existing `dev` namespace
- ✅ **Worker Nodes**: 
  - `mamad-workers-dev-*` (3 nodes)
  - `mamad-workers-staging-*` (3 nodes) 
  - `mamad-workers-production-*` (3 nodes)

### **Updated Configuration:**
- **Namespaces**: `dev`, `staging`, `production` (matches your cluster)
- **Node Selectors**: Apps will deploy to correct worker nodes
- **ArgoCD Apps**: Ready to sync with your existing ArgoCD

## 🚀 Deployment Commands

### 1. **Apply GitOps Configuration**
```bash
# Apply the platform project
kubectl apply -f argocd/projects/platform-project.yaml

# Apply all applications (12 total)
kubectl apply -f argocd/applications/

# Verify ArgoCD applications
kubectl get applications -n argocd
```

### 2. **Check Application Status**
```bash
# Check if applications are syncing
kubectl get applications -n argocd -o wide

# Check pods in each environment
kubectl get pods -n dev
kubectl get pods -n staging  
kubectl get pods -n production
```

### 3. **Access ArgoCD UI**
```bash
# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access: https://localhost:8080
# Username: admin
# Password: (from above command)
```

## 📋 Node Scheduling Strategy

### **Dev Environment**
- **Nodes**: `mamad-workers-dev-*`
- **Selector**: `node-role.kubernetes.io/worker: "true"`
- **Replicas**: 1 per app

### **Staging Environment**  
- **Nodes**: `mamad-workers-staging-*`
- **Selector**: `node-role.kubernetes.io/staging: "true"`
- **Replicas**: 2 per app

### **Production Environment**
- **Nodes**: `mamad-workers-production-*` 
- **Selector**: `node-role.kubernetes.io/production: "true"`
- **Replicas**: 3 per app + HPA

## 🔄 Next Steps

1. **Push GitOps repo** to GitHub
2. **Apply ArgoCD configurations** (commands above)
3. **Update CI pipelines** to push to this GitOps repo
4. **Monitor deployments** in ArgoCD UI

Your GitOps setup is now **perfectly aligned** with your existing cluster! 🎯