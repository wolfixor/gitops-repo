# Cluster Validation Guide

## 🔍 Validate YAML Against Your Cluster

### **1. Check Node Labels & Selectors**

**Your current dashboard uses:**
```yaml
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
      - matchExpressions:
          - key: node-role.kubernetes.io/cloud-container-g2
```

**Validate with kubectl:**
```bash
# Check what node labels actually exist
kubectl get nodes --show-labels

# Check if cloud-container-g2 label exists
kubectl get nodes -l node-role.kubernetes.io/cloud-container-g2=true

# See all node roles in your cluster
kubectl get nodes -o custom-columns=NAME:.metadata.name,ROLES:.metadata.labels
```

**Expected output should show nodes with `cloud-container-g2` label**

### **2. Check Tolerations**
```bash
# Check node taints
kubectl describe nodes | grep -A5 -B5 Taints

# Verify if 'role=cloud-container-g2' taint exists
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

### **3. Validate Scheduler**
```bash
# Check available schedulers
kubectl get pods -n kube-system | grep scheduler

# Verify default-scheduler exists
kubectl describe pod -n kube-system -l component=kube-scheduler
```

### **4. Test DNS Policy**
```bash
# Check DNS configuration
kubectl get configmap coredns -n kube-system -o yaml

# Verify ClusterFirst works
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default
```

### **5. Validate Namespaces**
```bash
# Check if your target namespaces exist
kubectl get namespaces

# Verify: dev, staging, production
kubectl get ns dev staging production
```

### **6. Test Resource Limits**
```bash
# Check if resource quotas exist in namespaces
kubectl describe quota -n production
kubectl describe quota -n staging
kubectl describe quota -n dev

# Check LimitRanges
kubectl get limitranges -A
```

### **7. Dry-Run Test Your Manifests**
```bash
# Test dashboard deployment
kubectl apply --dry-run=client -f apps/dashboard/base/deployment.yaml

# Test with server validation
kubectl apply --dry-run=server -f apps/dashboard/base/deployment.yaml

# Test complete kustomization
kustomize build apps/dashboard/overlays/prod | kubectl apply --dry-run=server -f -
```

### **8. Check Ingress Controller**
```bash
# Verify nginx ingress controller
kubectl get pods -n ingress-nginx

# Check ingress class
kubectl get ingressclass
```

### **9. Validate Secrets**
```bash
# Check if shared-secret exists in namespaces
kubectl get secrets -n production | grep shared-secret
kubectl get secrets -n staging | grep shared-secret
kubectl get secrets -n dev | grep shared-secret
```

## 🚨 Common Issues to Fix:

### **If node-role.kubernetes.io/cloud-container-g2 doesn't exist:**
```bash
# Check your actual node roles
kubectl get nodes --show-labels | grep node-role

# Update deployment to use correct labels, example:
# node-role.kubernetes.io/worker=true
# node-role.kubernetes.io/production=true
```

### **If tolerations don't match:**
```bash
# Check actual taints
kubectl describe nodes | grep Taints

# Update tolerations in YAML to match actual taints
```

### **Quick Fix Commands:**
```bash
# Label nodes if needed
kubectl label nodes <node-name> node-role.kubernetes.io/production=true

# Remove wrong labels
kubectl label nodes <node-name> node-role.kubernetes.io/cloud-container-g2-

# Add taints if needed
kubectl taint nodes <node-name> role=production:NoSchedule
```

## ✅ Validation Checklist:
- [ ] Node labels match YAML selectors
- [ ] Tolerations match node taints  
- [ ] Namespaces exist
- [ ] Scheduler exists
- [ ] DNS policy works
- [ ] Resource limits are valid
- [ ] Secrets exist
- [ ] Ingress controller running
- [ ] Dry-run passes