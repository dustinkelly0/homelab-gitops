# Troubleshooting

Common troubleshooting steps and commands:

- Check ArgoCD application health and sync status
- Inspect pod logs: `kubectl -n <ns> logs -l app=<app>`
- Check node conditions: `kubectl get nodes` and `talosctl ps` on nodes
- Validate manifests: `kubectl apply --dry-run=client -f <manifest>`

When escalating, include pod logs, event output, and ArgoCD application
history.
