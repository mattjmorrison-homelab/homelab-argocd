# homelab-argocd

Bootstrap ArgoCD into the k3s cluster. ArgoCD becomes the single tool used to deploy everything else to the cluster going forward.

## Install

```
kubectl apply -f manifests/namespace.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Wait for ArgoCD to be ready

```
kubectl wait --for=condition=available --timeout=120s deployment/argocd-server -n argocd
```

## Get the initial admin password

```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

## Access the UI

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open https://localhost:8080 and log in with username `admin` and the password from above.

## Point ArgoCD at homelab-apps

```
kubectl apply -f manifests/root-app.yaml
```

ArgoCD will start watching https://github.com/mattjmorrison/homelab-apps and deploy everything defined there.

## Upgrade ArgoCD

Re-apply the install manifest with a specific version tag:

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.14.0/manifests/install.yaml
```

ArgoCD handles its own rolling update.

## What comes next

- `homelab-apps` — an "App of Apps" repo that ArgoCD watches; contains an ArgoCD `Application` manifest for each tool to deploy
- `homelab-<tool>` — one repo per tool; each has its own manifests and lifecycle

To add a new tool: create a `homelab-<tool>` repo, then add an `Application` manifest pointing at it in `homelab-apps`. ArgoCD picks it up automatically.
