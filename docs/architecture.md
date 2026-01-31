# Architecture Overview

This document outlines the high-level architecture for the homelab GitOps
platform: a Kubernetes control plane (Talos Linux OS), ArgoCD for GitOps, and
shared platform services for storage, observability, and security.

Components
- Control plane: Kubernetes on Talos Linux
- Provisioning: Crossplane (optional) or manual bootstrap scripts
- GitOps: ArgoCD (app-of-apps pattern)
- Storage: NFS CSI + StorageClasses
- Observability: Prometheus, Grafana, Loki, Alertmanager
- Networking: MetalLB for L2 load balancing, Traefik as ingress

Operations
- Keep manifests in Git; ArgoCD reconciles clusters
- CI validates manifests and runs manifest linting
- Runbooks provide step-by-step operational procedures
