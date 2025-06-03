# Cogstack Observability Stack

This project runs a stack for observability of deployed software.

It provides the following features:
- Dashboards for availability
- Telemetry of infrastructure such as host memory usage, and elasticsearch index size
- Alerting based on a defined Service Level Objective (SLO) and burn rates
- Blackbox Probing of services to find service level indicators of uptime and latency
- A working inventory of what is running where

See the docs in the docs root folder for the full documentation

## Local Development

Run the stack locally with
```
cd ./observability/examples/simple
docker compose up -d
```

This will start the observability stack, set to probe and monitor itself.

Access Grafana on `http://localhost/grafana`