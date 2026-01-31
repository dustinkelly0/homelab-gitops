# ArgoCD CI account and RBAC

This guide shows a minimal, auditable way to create a CI service account for ArgoCD with least-privilege permissions and produce an API token for GitHub Actions.

Overview
- Create an ArgoCD role (`role:ci`) that grants only the permissions your CI needs (usually `applications get,sync` for specific app(s)).
- Add a local ArgoCD account (example: `ci-bot`) and map it to the role.
- Generate an API token for the account and store it in GitHub repository secrets (`ARGOCD_SERVER`, `ARGOCD_AUTH_TOKEN`).

Important: adapt the examples below to your security posture. Test safely and rotate tokens regularly.

1) Add RBAC policy (argocd-rbac-cm)

Create or patch the `argocd-rbac-cm` ConfigMap in the `argocd` namespace with a minimal policy. This example grants `role:ci` the ability to sync and get any `Application` in the `argocd` project.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.csv: |
    # allow role:ci to sync and get applications
    p, role:ci, applications, get, */*, allow
    p, role:ci, applications, sync, */*, allow
    # map user 'ci-bot' to role:ci
    g, ci-bot, role:ci
```

Apply it:

```bash
kubectl apply -f argocd-ci-rbac.yaml
```

2) Create a local ArgoCD account (argocd-cm)

Add an account in `argocd-cm` that allows API access. The `accounts.<name>` key enables the account and associates local auth methods.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  # enable a CI account named 'ci-bot' using 'apiKey' (local account)
  accounts.ci-bot: apiKey
```

Apply:

```bash
kubectl apply -f argocd-ci-account.yaml
```

Note: Using `apiKey` in `argocd-cm` means the account is configured for token-based auth; you will generate a token in the next step.

3) Generate a token for the CI account

Use the `argocd` CLI to generate a token for `ci-bot`:

```bash
# login as admin (or another user with permission to generate tokens)
argocd login <ARGOCD_SERVER> --username admin --password '<ADMIN_PASSWORD>' --insecure

# generate token for ci-bot
argocd account generate-token --account ci-bot
# copy the printed token and store it in GitHub as ARGOCD_AUTH_TOKEN
```

4) Store secrets in GitHub

- `ARGOCD_SERVER` — ArgoCD server host (e.g. `argocd.example.com` or `https://argocd.example.com`).
- `ARGOCD_AUTH_TOKEN` — the token you generated above.

Security tips
- Use a dedicated CI account with the smallest set of permissions required.
- Prefer scoping policies to specific applications instead of `*` when possible.
- Store tokens as GitHub repository secrets and rotate periodically.

If you want, I can generate sample YAML files (`argocd-ci-rbac.yaml`, `argocd-ci-account.yaml`) in the repo and add instructions to the bootstrap script. Would you like that? 
