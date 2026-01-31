# Scaling Guide

Guidance for scaling workloads and cluster capacity:

- Monitor CPU/memory and target 70% utilization thresholds
- Add node pools for workload isolation (e.g., media vs infra)
- Use storageClasses with reclaimPolicy and allowVolumeExpansion
- Test scale-up under load and verify autoscaler behavior
