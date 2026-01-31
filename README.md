# Homelab GitOps

This repository contains a production-oriented GitOps layout for running a
personal homelab. It includes declarative manifests, platform tooling, app
deployments, operational runbooks, and automation scripts.

Principles
- Declarative manifests as single source of truth
- Small blast radius with namespaced application deployments
- Observability and automated validation in CI
- Documented runbooks and ADRs for operational clarity

Layout
- `docs/`: architecture, ADRs, runbooks, SLOs
- `infrastructure/`: platform and infra manifests
- `platform/`: ArgoCD, Crossplane, and app-of-apps
- `applications/`: curated application deployments
- `scripts/`: operational automation
- `tests/`: smoke and integration checks

See `docs/architecture.md` for the system design and `docs/runbooks/` for
operational procedures.

License: MIT
# Kubernetes Homelab - GitOps Infrastructure

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/kubernetes-v1.30-blue.svg)](https://kubernetes.io/)
[![ArgoCD](https://img.shields.io/badge/argocd-gitops-orange.svg)](https://argoproj.github.io/argo-cd/)

## 🏗️ Architecture

Kubernetes homelab running on Talos Linux with complete GitOps workflow.

### Key Features
- 🔄 **GitOps**: Automated deployments with ArgoCD
- 📦 **Storage**: NFS CSI with Synology NAS integration
- 📊 **Observability**: Prometheus, Grafana, Loki stack
- 🔒 **Security**: RBAC, Network Policies, Sealed Secrets
- 🔧 **Infrastructure as Code**: All configs in Git
- ✅ **CI/CD**: Automated testing and validation

## 📁 Repository Structure
```
.
├── infrastructure/     # Core platform components
├── applications/       # Application deployments
├── platform/          # ArgoCD and platform tools
├── scripts/           # Automation scripts
└── docs/              # Documentation
```

## 🚀 Quick Start

See [Getting Started](docs/getting-started.md) for installation instructions.

## 📚 Documentation

- [Architecture Overview](docs/architecture/overview.md)
- [Runbooks](docs/runbooks/)
- [Troubleshooting Guide](docs/reference/troubleshooting-guide.md)

## 🎯 Project Goals

- [ ] Pass CKA Certification
- [ ] Implement SRE best practices
- [ ] Maintain 99.9% uptime SLO
- [ ] Automate all operational tasks

## 📊 Current Status

| Component | Status | Version |
|-----------|--------|---------|
| Kubernetes | 🟢 Running | v1.30.0 |
| ArgoCD | 🟢 Synced | v2.10.0 |
| Prometheus | 🟢 Running | v2.48.0 |
| Grafana | 🟢 Running | v10.2.0 |

## 🤝 Contributing

This is a personal learning project, but issues and suggestions are welcome!

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.
