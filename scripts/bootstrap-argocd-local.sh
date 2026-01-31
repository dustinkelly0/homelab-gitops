#!/usr/bin/env bash
set -euo pipefail

# Bootstrap ArgoCD locally and apply the app-of-apps Application.
# Usage: ./scripts/bootstrap-argocd-local.sh --repo-url <git-repo-url>

REPO_URL=""
INSTALL_CI_RBAC="false"
while [[ $# -gt 0 ]]; do
  case $1 in
    --repo-url) REPO_URL="$2"; shift 2;;
    --install-ci-rbac) INSTALL_CI_RBAC="true"; shift 1;;
    -h|--help) echo "Usage: $0 --repo-url <git-repo-url> [--install-ci-rbac]"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

if [ -z "$REPO_URL" ]; then
  echo "You must pass --repo-url pointing to the Git repo where this project is hosted."
  echo "Example: ./scripts/bootstrap-argocd-local.sh --repo-url https://github.com/your-org/homelab-gitops [--install-ci-rbac]"
  exit 2
fi

# Apply ArgoCD official install manifest
echo "Creating namespace: argocd"
kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -

echo "Installing ArgoCD core manifests"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for server to be ready (simple wait)
echo "Waiting for argocd-server to be ready..."
kubectl -n argocd wait --for=condition=available deployment/argocd-server --timeout=120s || true

# Ensure Application CRD exists (tools/crds/application-crd.yaml is included in repo)
if [ -f "tools/crds/application-crd.yaml" ]; then
  echo "Applying local ArgoCD Application CRD"
  kubectl apply -f tools/crds/application-crd.yaml
fi

# Create a temporary app-of-apps manifest with the provided repo URL
TMP=$(mktemp)
sed "s|https://github.com/YOUR_ORG/homelab-gitops|${REPO_URL}|g" platform/argocd/app-of-apps.yaml > "$TMP"

echo "Applying app-of-apps (pointing at ${REPO_URL})"
kubectl apply -f "$TMP"
rm -f "$TMP"

# Optionally install CI RBAC helpers
if [ "$INSTALL_CI_RBAC" = "true" ]; then
  echo "Installing CI RBAC resources (argocd-ci-rbac.yaml, argocd-ci-account.yaml)"
  kubectl apply -f platform/argocd/argocd-ci-rbac.yaml || true
  kubectl apply -f platform/argocd/argocd-ci-account.yaml || true
  echo "CI RBAC resources applied. Review and adjust policy.csv to scope permissions as needed."
fi

echo "Bootstrap complete."

echo "Next steps:"
echo "  1. Install SealedSecrets / cert-manager if you plan to use them before apps that depend on them."
echo "  2. Login to ArgoCD server:"
echo "     kubectl port-forward svc/argocd-server -n argocd 8080:443 &"
echo "     # default admin password is the argocd-server pod name or set via argocd-values.yaml"
echo "  3. Use the ArgoCD UI at https://localhost:8080 or the CLI to watch the apps reconcile."
