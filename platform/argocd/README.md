# ArgoCD Usage Notes

This document covers generating an ArgoCD API token suitable for CI and where to store it for GitHub Actions.

## Generate an ArgoCD API token (CLI)

1. Install the `argocd` CLI (homebrew or download the binary for your OS).
2. Login to your ArgoCD server (replace `ARGOCD_SERVER`, `ADMIN_USER`, and `ADMIN_PASSWORD`):

```bash
argocd login $ARGOCD_SERVER --username $ADMIN_USER --password "$ADMIN_PASSWORD" --insecure
```

3. Generate a token for the account you want to use in CI (for short-lived testing you can use `admin`, but create a dedicated account for CI in production):

```bash
argocd account generate-token --account <username>
# example: argocd account generate-token --account admin
```

The command prints a token string. Copy it — this is your `ARGOCD_AUTH_TOKEN`.

## Generate a token (UI)

- Log in to the ArgoCD web UI.
- Click your username (top-right) → `User Settings` → `Generate Token`.
- Copy the token and store it securely.

## Recommended: use a dedicated CI account

- Create a dedicated ArgoCD account for CI with the minimal RBAC required to sync the apps you need.
- Avoid using the `admin` account in CI; limit scope and rotate tokens regularly.

## Store the token and server in GitHub Actions

Add two repository secrets in GitHub (Repository → Settings → Secrets):

- `ARGOCD_SERVER` — the ArgoCD server hostname (e.g., `argocd.example.com` or `argocd.example.com:443`).
- `ARGOCD_AUTH_TOKEN` — the token generated above.

Workflow example (already used in this repo) logs in with the token:

```bash
argocd login "$ARGOCD_SERVER" --insecure --auth-token "$ARGOCD_AUTH_TOKEN"
argocd app sync app-of-apps --prune --refresh
```

## Security notes

- Keep tokens in the repository secrets store (never commit plaintext tokens).
- Prefer API tokens generated for a dedicated service user with least privilege.
- Rotate tokens regularly and remove unused tokens.

If you want, I can add a script that creates a CI user and bootstraps minimal RBAC for it. 
