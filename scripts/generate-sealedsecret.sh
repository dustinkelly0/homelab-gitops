#!/usr/bin/env bash
set -euo pipefail

# generate-sealedsecret.sh
# Usage:
#  ./scripts/generate-sealedsecret.sh --name sample-app-secret --namespace apps --from-literal password=SUPER_SECRET [--cert /path/to/pub-cert.pem]
# If --cert is provided, the script will run kubeseal with that cert. If not, it will try to call kubeseal which contacts the controller (requires kubeconfig access).

NAME="sample-app-secret"
NS="apps"
CERT=""
OUTPUT_DIR="platform/argocd/secrets"

ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --name) NAME="$2"; shift 2;;
    --namespace) NS="$2"; shift 2;;
    --cert) CERT="$2"; shift 2;;
    --output) OUTPUT_DIR="$2"; shift 2;;
    --from-literal|--from-file) ARGS+=("$1" "$2"); shift 2;;
    -h|--help) sed -n '1,120p' "$0"; exit 0;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

mkdir -p "$OUTPUT_DIR"
TMP_SECRET=$(mktemp)

echo "Creating temporary Kubernetes Secret manifest for '${NAME}' in namespace '${NS}'"
kubectl create secret generic "$NAME" --namespace "$NS" "${ARGS[@]}" --dry-run=client -o yaml > "$TMP_SECRET"

SEALED_OUT="$OUTPUT_DIR/${NAME}.sealed.yaml"
if command -v kubeseal >/dev/null 2>&1; then
  echo "kubeseal found"
  if [ -n "$CERT" ]; then
    echo "Sealing using cert: $CERT"
    kubeseal --cert "$CERT" < "$TMP_SECRET" > "$SEALED_OUT"
  else
    echo "Attempting to contact SealedSecrets controller via kubeseal (requires kubeconfig access)"
    if kubeseal --fetch-cert >/dev/null 2>&1; then
      kubeseal < "$TMP_SECRET" > "$SEALED_OUT"
    else
      echo "kubeseal could not fetch controller cert; you can re-run with --cert /path/to/controller-cert.pem"
      rm -f "$TMP_SECRET"
      exit 2
    fi
  fi
  echo "Sealed secret written to: $SEALED_OUT"
  rm -f "$TMP_SECRET"
  exit 0
else
  echo "kubeseal not installed. Created a plain secret manifest at: $TMP_SECRET"
  echo "To produce a sealed secret, install kubeseal and run this script with --cert <controller-cert.pem> or ensure kubeseal can contact the controller via kubeconfig."
  echo "Template secret file: $TMP_SECRET"
  echo "You can also seal manually with: kubeseal --cert <cert.pem> < $TMP_SECRET > ${SEALED_OUT}"
  exit 1
fi
