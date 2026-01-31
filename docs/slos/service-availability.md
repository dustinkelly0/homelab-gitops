# Service Availability SLO

Objective: Keep platform services available to users.

- SLI: 5m rolling success rate of HTTP checks for user-facing services
- SLO: 99.9% availability per calendar month
- Error budget: 43.2 minutes per month

Monitoring: uptime checks via Prometheus blackbox exporter and synthetic
tests; alert when error budget consumption is high.
