# Disaster Recovery

Steps to recover from full cluster failure:

1. Restore control plane nodes using Talos OS image and saved machine configs.
2. Restore etcd from the latest `backup-etcd` snapshot.
3. Reconnect ArgoCD to the Git repository and let it reconcile.
4. Re-apply external DNS and load balancer configuration.
5. Validate platform services and run smoke tests.

Keep backups offsite and verify restore quarterly.
