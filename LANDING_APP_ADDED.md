# Landing Complex App Added to GitOps

## ✅ Landing App Successfully Added!

### **📁 New Structure:**
```
apps/landing/
├── base/
│   ├── deployment.yaml      # Production-ready config
│   ├── service.yaml         # ClusterIP service
│   ├── ingress.yaml         # www.wolfixsite.shop domain
│   └── kustomization.yaml   # Base configuration
└── overlays/
    ├── dev/                 # Development environment
    ├── staging/             # Staging environment
    └── prod/                # Production environment + HPA
```

### **🎯 Configuration Details:**

**Base Configuration (Production):**
- **Image**: `wolfix1245/landing:1.0`
- **Resources**: 500m CPU, 1000Mi memory
- **Domain**: `www.wolfixsite.shop`
- **Port**: 3000 → 80

**Environment Variations:**
- **Dev**: Reduced resources, `dev.wolfixsite.shop`
- **Staging**: Medium resources, `staging.wolfixsite.shop`  
- **Production**: Full resources + HPA (1-3 replicas)

### **🚀 Deployment Commands:**

**1. Apply ArgoCD Application:**
```bash
kubectl apply -f argocd/applications/landing-app.yaml
```

**2. Verify Deployment:**
```bash
# Check ArgoCD applications
kubectl get applications -n argocd | grep landing

# Check pods in each environment
kubectl get pods -n dev -l app=landingcomplex-app
kubectl get pods -n staging -l app=landingcomplex-app
kubectl get pods -n production -l app=landingcomplex-app
```

**3. Access URLs:**
- **Production**: https://www.wolfixsite.shop
- **Staging**: https://staging.wolfixsite.shop
- **Development**: https://dev.wolfixsite.shop

### **🔄 CI Integration:**
Add this to your landing app CI pipeline:

```yaml
- name: Update GitOps Repository
  run: |
    git clone https://${{ secrets.GITOPS_TOKEN }}@github.com/wolfixor/gitops-platform.git
    cd gitops-platform
    
    # Update image tag for landing app
    sed -i "s|newTag: \".*\"|newTag: \"${{ github.sha }}\"|g" \
      apps/landing/overlays/${{ env.ENV }}/kustomization.yaml
    
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git commit -m "🚀 Update landing image to ${{ github.sha }} for ${{ env.ENV }}"
    git push origin main
```

### **📊 Total Applications:**
Your GitOps repository now manages **5 applications**:
1. ✅ Dashboard (production-ready)
2. 🔧 Complex (template)
3. 🔧 Payment (template)
4. 🔧 UserWebsite (template)
5. ✅ Landing (production-ready)

**Total ArgoCD Apps**: 15 (5 apps × 3 environments)

The landing app is now **production-ready** and integrated into your GitOps workflow! 🎉