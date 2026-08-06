# Zahra GitOps

A GitOps repository for Kubernetes using ArgoCD. Single-cluster, category-based app organization — apply once and ArgoCD manages everything from git.

## Bootstrap

Install ArgoCD, then apply the bootstrap manifest:

```bash
helm install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  -f bootstrap/argo-cd/chart/values.yaml

kubectl apply -f bootstrap.yaml
```

ArgoCD self-heals from this point. Everything else is driven by git.

## Repository Structure

```
bootstrap/
  argo-cd/          # ArgoCD self-managed install (Helm chart + values)
  argo-cd.yaml      # Application: manages ArgoCD itself
  root.yaml         # Application: deploys all ApplicationSets from apps/
bootstrap.yaml      # Apply once to bootstrap any cluster

apps/
  ai/               # AI & automation workloads (n8n, etc.)
  platform/         # Platform infrastructure (vault, external-secrets, etc.)
  datastore/        # Databases and data stores (postgres, redis, etc.)
  storage/          # Persistent storage (Longhorn, MinIO, etc.)
  monitoring/       # Observability (Prometheus, Grafana, etc.)
  network/          # Networking (MetalLB, ingress-nginx, etc.)
  security/         # Security tooling (cert-manager, vault, etc.)
```

Each category folder has an `appset.yaml` (ApplicationSet) that auto-discovers apps via `config.yaml` files.

## Adding an App

Drop a `config.yaml` (and your Helm chart or manifests) into the right category:

```
apps/monitoring/grafana/
  config.yaml       # triggers ArgoCD Application creation
  Chart.yaml        # Helm wrapper chart
  values.yaml
```

ArgoCD picks it up automatically within `requeueAfterSeconds` (20s).

## config.yaml Fields

The presence of `config.yaml` is what triggers app creation. It can be empty — all fields have defaults derived from the directory path.

| Field | Default |
|---|---|
| `appName` | directory basename |
| `destNamespace` | directory basename |
| `repoURL` | `https://github.com/n4if11/zahra` |
| `srcPath` | path to the directory containing `config.yaml` |
| `srcTargetRevision` | `HEAD` |
| `noAutoSync` | `false` — set to `"true"` to disable auto-sync |

Example override:

```yaml
# apps/datastore/postgres/config.yaml
destNamespace: databases
noAutoSync: "true"
```

## Network

MetalLB (L2 mode) provides LoadBalancer IPs from `192.168.23.200-192.168.23.250`.
Ingress-nginx is the cluster ingress controller.
ArgoCD is exposed at `https://argocd.local` via ingress-nginx with TLS.

Add to your hosts file (`C:\Windows\System32\drivers\etc\hosts` on Windows):
```
192.168.23.200  argocd.local
```

## TLS / cert-manager

cert-manager manages TLS certificates for all ingresses. The trust chain:

```
ClusterIssuer: selfsigned   ← bootstraps the root CA (used once)
      ↓
Certificate: local-ca       ← root CA cert (isCA: true)
      ↓
ClusterIssuer: local-ca     ← signs all ingress certs
      ↓
Certificate: <app>-tls      ← per-app TLS cert → Secret → ingress-nginx
```

To annotate any ingress for automatic TLS:
```yaml
annotations:
  cert-manager.io/cluster-issuer: local-ca
```

### Trusting the CA on Windows (one-time setup)

```bash
kubectl get secret local-ca-secret -n cert-manager \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > local-ca.crt
```

Copy `local-ca.crt` to Windows, double-click → Install Certificate → Local Machine → Trusted Root Certification Authorities. Restart the browser.
