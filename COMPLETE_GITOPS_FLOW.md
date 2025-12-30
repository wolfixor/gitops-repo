# 🔄 Complete CI/CD GitOps Flow

## 📊 Current GitOps Repository Structure

**5 Applications Ready:**
- ✅ **Dashboard**: Production-ready
- ✅ **Complex**: Production-ready  
- ✅ **UserWebsite**: Production-ready
- ✅ **Landing**: Production-ready
- 🔧 **Payment**: Template only

**Each app has 3 environments:** dev, staging, production

## 🚀 How CI Updates GitOps Tags

### **Step 1: Application CI Pipeline**
When you push code to any app repository:

```yaml
# In dashboard repo: .github/workflows/deploy.yml
- name: Update GitOps Repository
  if: github.event_name == 'push' && success()
  run: |
    # Clone GitOps repo
    git clone https://${{ secrets.GITOPS_TOKEN }}@github.com/wolfixor/gitops-platform.git
    cd gitops-platform
    
    # Update image tag based on environment
    case "${{ env.ENV }}" in
      prod)
        sed -i "s|newTag: \".*\"|newTag: \"${{ github.sha }}\"|g" \
          apps/dashboard/overlays/prod/kustomization.yaml
        ;;
      staging)
        sed -i "s|newTag: \".*\"|newTag: \"${{ github.sha }}\"|g" \
          apps/dashboard/overlays/staging/kustomization.yaml
        ;;
      dev)
        sed -i "s|newTag: \".*\"|newTag: \"${{ github.sha }}\"|g" \
          apps/dashboard/overlays/dev/kustomization.yaml
        ;;
    esac
    
    # Commit and push changes
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git commit -m "🚀 Update dashboard image to ${{ github.sha }} for ${{ env.ENV }}"
    git push origin main
```

### **Step 2: Tag Update Examples**

**Before CI run:**
```yaml
# apps/dashboard/overlays/prod/kustomization.yaml
images:
  - name: wolfix1245/dashboard
    newTag: "5e9486eb26856ddf7911454d4a42c273f7733a8d"  # Old commit
```

**After CI run:**
```yaml
# apps/dashboard/overlays/prod/kustomization.yaml
images:
  - name: wolfix1245/dashboard
    newTag: "a1b2c3d4e5f6789012345678901234567890abcd"  # New commit SHA
```

### **Step 3: ArgoCD Detection & Deployment**

**ArgoCD watches GitOps repo:**
```yaml
# argocd/applications/dashboard-app.yaml
spec:
  source:
    repoURL: https://github.com/wolfixor/gitops-platform
    path: apps/dashboard/overlays/prod  # Watches this path
    targetRevision: HEAD
  syncPolicy:
    automated:  # Auto-sync enabled for dev/staging
      prune: true
      selfHeal: true
```

**ArgoCD Process:**
1. **Detects change** in `apps/dashboard/overlays/prod/kustomization.yaml`d
2. **Pulls new tag** from Docker Hub: `wolfix1245/dashboard:a1b2c3d4...`
3. **Updates Kubernetes** deployment with new image
4. **Rolls out** new pods with zero downtime

## 🔄 Complete Flow Diagram

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   App Repo      │    │   GitOps Repo    │    │   Kubernetes    │
│  (dashboard)    │    │  (gitops-repo)   │    │    Cluster      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                       │                       │
    1. Code Push                 │                       │
         │                       │                       │
    2. CI Pipeline               │                       │
         │                       │                       │
    3. Build Docker ─────────────┼──────────────────────▶│
         │                       │                Docker │
    4. Update GitOps ────────────▶                      │
         │                Tag Update                     │
         │                       │                       │
         │                  5. ArgoCD Detects            │
         │                     Change                    │
         │                       │                       │
         │                       │                  6. Deploy
         │                       │                    New Image
         │                       │                       │
         │                       │                  7. Rolling
         │                       │                    Update
```

## 🎯 Environment-Specific Updates

**Production (main branch):**
- Updates: `apps/*/overlays/prod/kustomization.yaml`
- Uses: Commit SHA tags (immutable)
- ArgoCD: Manual sync (requires approval)

**Staging (staging branch):**
- Updates: `apps/*/overlays/staging/kustomization.yaml`
- Uses: Commit SHA tags
- ArgoCD: Auto-sync enabled

**Development (dev branch):**
- Updates: `apps/*/overlays/dev/kustomization.yaml`
- Uses: `dev-latest` or commit SHA
- ArgoCD: Auto-sync enabled

## 🔧 Required Setup

**1. Add GitOps update to each app's CI:**
```yaml
# Add this step to dashboard, complex, userwebsite, landing repos
- name: Update GitOps Repository
  # ... (code above)
```

**2. Create GITOPS_TOKEN secret:**
- GitHub Personal Access Token with repo access
- Add to each app repository secrets

**3. ArgoCD Applications:**
```bash
# Deploy ArgoCD apps (already created)
kubectl apply -f argocd/applications/dashboard-app.yaml
kubectl apply -f argocd/applications/complex-app.yaml
kubectl apply -f argocd/applications/userwebsite-app.yaml
kubectl apply -f argocd/applications/landing-app.yaml
```

## ✅ End Result

**Fully automated GitOps pipeline:**
1. **Developer pushes code** → CI builds image
2. **CI updates GitOps repo** → New image tag committed
3. **ArgoCD detects change** → Pulls new image
4. **Kubernetes deploys** → Zero-downtime rollout

**Your GitOps repository is the single source of truth for all deployments!** 🎯