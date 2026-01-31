# ADR 0002 — NFS vs Ceph for Home Storage

Decision: Start with NFS CSI (Synology) for simplicity; evaluate Ceph later if
requirements increase.

Rationale:
- NFS is simple to operate for home NAS-backed storage
- Ceph provides stronger resilience but higher operational overhead
