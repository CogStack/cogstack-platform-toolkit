# Production Setup Tutorial
//In Progress
This tutorial guides you through setting up the **CogStack Observability Stack** for production use.

If you're new, we recommend completing the [Quickstart Tutorial](../quickstart.md) first to get a simplified setup running.

By the end of the tutorial, you will have a complete stack offering all the observability features, customized to your usage. 

---

## Step 1: Understand the Folder Structure

Your project configuration should follow this structure:

```
observability.docker-compose.yml
exporters.docker-compose.yml
prometheus/
    scrape-configs/
        exporters/         # Targets that expose metrics (e.g. Elasticsearch, Docker, VMs)
        probers/           # HTTP endpoints to check availability
    recording-rules/       # Prometheus recording rules (e.g. for SLOs, summaries)
    blackbox-exporter/     # (Optional) Custom Probe configuration
grafana/                   # (Optional) Custom Grafana dashboards and config
```

## Step 2: Initialise the project

Run:
```bash
curl https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/refs/heads/main/observability/examples/full/full-quickstart.sh | bash
```

This script will setup all the folder structure, and download all the relevant files.

### Script Details
The script automates making folders, and downloading these files:

Downloads the example docker compose files:
- [docker-compose.yml](../../../observability/examples/full/docker-compose.yml)
- [exporters.docker-compose.yml](../../../observability/examples/full/exporters.docker-compose.yml)
- [exporters.elastic.docker-compose.yml](../../../observability/examples/full/exporters.elastic.docker-compose.yml)

Downloads the prometheus configurations:
- [prometheus/scrape-configs/exporters/exporters.yml](../../../observability/examples/full/prometheus/scrape-configs/exporters/exporters.yml)
- [prometheus/scrape-configs/probers/probe-external.ymll](../../../observability/examples/full/prometheus/scrape-configs/probers/probe-external.yml)
- [prometheus/scrape-configs/probers/probe-internal.yml ](../../../observability/examples/full/prometheus/scrape-configs/probers/probe-internal.yml)
- [prometheus/scrape-configs/recording-rules/slo.yml](../../../observability/examples/full/prometheus/scrape-configs/recording-rules/slo.yml)


Inspect the results in your local directory, and see that it matches the folder layout defined in step 1. 

## Step 3: Run the Stack
The files come with basic defaults, so we can now run the stack


   ```
   docker compose up -d
   docker compose -f exporters.docker-compose.yml up -d
   ```

This will launch Prometheus, Grafana, and all required services with 


## Step 4: Create Site-Specific Config Files

You must provide your own scrape and recording rules to tell Prometheus what to monitor.

* Exporters: Targets like Elasticsearch or Docker
  → Add files in `scrape-configs/exporters/*.yml`

* Probers: HTTP endpoints you want to monitor for availability
  → Add files in `scrape-configs/probers/*.yml`

* Recording Rules: Define uptime goals or custom aggregations
  → Add files in `recording-rules/*.yml`

Refer to the following How-To guides for creating each config:

* [Configure Probers](./probing.md)
* [Add Exporters](./telemetry.md)
* [Enable Alerting](./alerting.md)
* [Customise Setup](../customization/_index.md)

---



---

## What’s Next?

Your observability stack is now monitoring your own services.

Continue with:

* [Grafana Dashboards](./dashboards.md)
* [Set up Alerts](./alerting.md)
* [Create custom views](../customization/_index.md)

---

Let me know if you'd like to add code snippets for `.yml` examples in each folder.
