# GitOps Platform Repository

This repository contains Kubernetes manifests and ArgoCD configurations for the entire platform.

## Repository Structure

```
├── apps/                    # Application manifests
│   ├── dashboard/          # Dashboard application
│   ├── complex/            # Complex application  
│   ├── payment/            # Payment application
│   ├── userwebsite/        # User website application
│   └── landing/            # Landing complex application
├── argocd/                 # ArgoCD configurations
│   ├── applications/       # ArgoCD Application definitions
│   └── projects/          # ArgoCD Project definitions
├── infrastructure/         # Shared infrastructure
│   ├── namespaces/        # Namespace definitions
│   ├── ingress-controller/ # Ingress controller setup
│   └── monitoring/        # Monitoring stack
└── policies/              # Security and governance policies
```

## Applications

### 1. Dashboard
- **Repository**: wolfixor/complex-dashboard-production
- **Image**: wolfix1245/dashboard
- **Environments**: dev, staging, prod

### 2. Complex
- **Repository**: wolfixor/complex-production
- **Image**: wolfix1245/complex
- **Environments**: dev, staging, prod

### 3. Payment
- **Repository**: wolfixor/payment-production
- **Image**: wolfix1245/payment
- **Environments**: dev, staging, prod

### 4. User Website
- **Repository**: wolfixor/userwebsite-production
- **Image**: wolfix1245/userwebsite
- **Environments**: dev, staging, prod

### 5. Landing Complex
- **Repository**: wolfixor/landing-production
- **Image**: wolfix1245/landing
- **Environments**: dev, staging, prod

## Deployment Flow

1. **CI Pipeline** builds and pushes Docker images
2. **CI Pipeline** updates image tags in this repository
3. **ArgoCD** detects changes and deploys to Kubernetes
4. **Monitoring** tracks deployment status and health

## Environment Promotion

- **Dev**: Auto-sync enabled, immediate deployment
- **Staging**: Auto-sync with health checks
- **Production**: Manual sync, requires approval

## Getting Started

1. Install ArgoCD in your cluster
2. Apply ArgoCD projects and applications
3. Configure CI pipelines to update image tags
4. Monitor deployments through ArgoCD UI

## Security

- All images use immutable SHA tags
- Network policies enforce traffic isolation
- Resource quotas prevent resource exhaustion
- Pod security policies enforce security standards