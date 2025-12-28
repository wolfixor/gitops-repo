# 📚 Kubernetes Concepts Explained - Educational Guide

## 🎯 What We Fixed and Why

### **1. Node Affinity & Node Selectors**

**What is it?**
Node Affinity tells Kubernetes which nodes your pods should run on.

**Your Original YAML:**
```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: node-role.kubernetes.io/cloud-container-g2
              operator: In
              values:
                - "true"
```

**What this means:**
- "Only schedule this pod on nodes that have the label `node-role.kubernetes.io/cloud-container-g2=true`"
- `requiredDuringSchedulingIgnoredDuringExecution` = "MUST have this label, or don't schedule at all"

**Why it failed:**
Your cluster doesn't have nodes with `cloud-container-g2` label. We found:
- Production nodes: `node-role.kubernetes.io/production=worker-production`
- Staging nodes: `node-role.kubernetes.io/staging=worker-staging`
- Dev nodes: `node-role.kubernetes.io/worker=worker-dev`

**Fixed version:**
```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: node-role.kubernetes.io/production
              operator: In
              values:
                - "worker-production"
```

### **2. Tolerations & Taints**

**What are Taints and Tolerations?**
- **Taint**: A "repellent" on a node that prevents pods from scheduling
- **Toleration**: A "permission" on a pod to ignore specific taints

**Your Original YAML:**
```yaml
tolerations:
  - key: role
    operator: Equal
    value: cloud-container-g2
    effect: NoSchedule
```

**What this means:**
- "This pod can tolerate (ignore) the taint `role=cloud-container-g2:NoSchedule`"

**Why we removed it:**
Your cluster output showed:
```
Taints: <none>
```
Your worker nodes have NO taints, so tolerations are unnecessary.

**When you need tolerations:**
Only when nodes have taints. For example:
```bash
# If a node had this taint:
kubectl taint nodes node1 role=database:NoSchedule

# Then pods would need this toleration:
tolerations:
- key: role
  operator: Equal
  value: database
  effect: NoSchedule
```

### **3. DNS Policy**

**What is `dnsPolicy: ClusterFirst`?**
```yaml
dnsPolicy: ClusterFirst
```

**DNS Resolution Order:**
1. **ClusterFirst**: Check cluster DNS first, then external DNS
2. **Default**: Use node's DNS settings
3. **None**: No DNS (you provide custom config)

**Why ClusterFirst is good:**
- Resolves service names like `dashboard-app.production.svc.cluster.local`
- Falls back to external DNS for internet domains
- Standard for most applications

**Test it:**
```bash
# This should work with ClusterFirst
kubectl run test --image=busybox --rm -it -- nslookup kubernetes.default
```

### **4. Scheduler Name**

**What is `schedulerName: default-scheduler`?**
```yaml
schedulerName: default-scheduler
```

**What schedulers do:**
- Decide which node gets your pod
- Consider resources, affinity, taints, etc.
- `default-scheduler` is Kubernetes' built-in scheduler

**Check your scheduler:**
```bash
kubectl get pods -n kube-system | grep scheduler
```

**Custom schedulers:**
You can write custom schedulers for special logic, but 99% of cases use default.

### **5. Resource Management**

**Your YAML has:**
```yaml
resources:
  requests:
    cpu: "500m"
    memory: "1000Mi"
    ephemeral-storage: "1Gi"
  limits:
    cpu: "1000m"
    memory: "2000Mi"
    ephemeral-storage: "1Gi"
```

**What this means:**
- **Requests**: "I need at least this much" (used for scheduling)
- **Limits**: "Don't let me use more than this" (enforced at runtime)
- **CPU**: `500m` = 0.5 CPU cores, `1000m` = 1 CPU core
- **Memory**: `1000Mi` = 1000 MiB (mebibytes)
- **Ephemeral Storage**: Temporary disk space

**Why important:**
- Scheduler uses requests to find nodes with enough resources
- Limits prevent one pod from consuming all node resources

### **6. Restart Policy & Grace Period**

**Your YAML:**
```yaml
restartPolicy: Always
terminationGracePeriodSeconds: 30
```

**Restart Policies:**
- **Always**: Restart if pod crashes (default for Deployments)
- **OnFailure**: Only restart if exit code != 0
- **Never**: Don't restart

**Grace Period:**
- Time Kubernetes waits before force-killing a pod
- Allows graceful shutdown (close connections, save data)
- After 30 seconds, sends SIGKILL (force kill)

### **7. Rolling Update Strategy**

**Your YAML:**
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 25%
    maxUnavailable: 0
```

**What this means:**
- **RollingUpdate**: Replace pods gradually (vs Recreate = kill all, then create)
- **maxSurge: 25%**: Can have 25% extra pods during update
- **maxUnavailable: 0**: Never have fewer than desired replicas

**Example with 4 replicas:**
- maxSurge 25% = can have 5 pods (4 + 1 extra)
- maxUnavailable 0 = always keep 4 running
- Result: Zero-downtime deployments

### **8. Revision History**

**Your YAML:**
```yaml
revisionHistoryLimit: 3
```

**What it does:**
- Keeps last 3 ReplicaSets for rollback
- Older ReplicaSets are deleted to save space

**Rollback example:**
```bash
# See deployment history
kubectl rollout history deployment/dashboard-app

# Rollback to previous version
kubectl rollout undo deployment/dashboard-app

# Rollback to specific revision
kubectl rollout undo deployment/dashboard-app --to-revision=2
```

## 🧪 Validation Commands Explained

### **Check Node Labels:**
```bash
kubectl get nodes --show-labels
```
Shows all labels on nodes. Labels are key-value pairs for organizing resources.

### **Filter by Labels:**
```bash
kubectl get nodes -l node-role.kubernetes.io/production=worker-production
```
Only shows nodes with that specific label.

### **Dry-run Validation:**
```bash
kubectl apply --dry-run=server -f deployment.yaml
```
- **client**: Only validates YAML syntax
- **server**: Validates against cluster (checks if resources exist, permissions, etc.)

### **Describe Resources:**
```bash
kubectl describe nodes
kubectl describe pod <pod-name>
```
Shows detailed information including events, which helps debug scheduling issues.

## 🎓 Key Takeaways

1. **Always validate YAML against your actual cluster**
2. **Node selectors must match existing node labels**
3. **Tolerations only needed if nodes have taints**
4. **Use dry-run to catch errors before deployment**
5. **Resource requests/limits are crucial for stability**
6. **Rolling updates enable zero-downtime deployments**

**Understanding these concepts helps you:**
- Debug pod scheduling issues
- Optimize resource usage
- Ensure high availability
- Troubleshoot deployment problems