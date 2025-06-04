# Production Setup Tutorial
This tutorial guides you through setting up the **CogStack Observability Stack** for production use.

If you're new, we recommend completing the [Quickstart Tutorial](../get-started/quickstart.md) first to get a simplified setup running.

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

This is probably the hardest step: You will actually need to know what is running, and where it is! Building out these config files will give you that inventory, and give a real definition of what is running where.

- Probers: HTTP endpoints you want to monitor for availability
  - Add files in `scrape-configs/probers/*.yml`
  - [Configure Probers](./probing.md)
  
- Exporters: Targets like Elasticsearch or Docker
  - Add files in `scrape-configs/exporters/*.yml`
  - [Add Exporters](./telemetry.md)

- Recording Rules: Define uptime goals or custom aggregations
  - Add files in `recording-rules/*.yml`
  - [Enable Alerting](./alerting.md)

## Step 5: Run Exporters Everywhere
The exporters need to be run on each VM that you want information from. It's a pull model, not push.


---

## What’s Next?

Your observability stack is now monitoring your services, and you have a production ready project setup

You can now setup prometheus with any telemetry or probers required following the remaining steps in [Setup](./_index.md)

For the last steps, you can 

- Run the exporters on all the VMs that you want access to 
- Deploy the stack in produciton
- Fully customise with [Customization](../customization/_index.md)
- Look further into understanding the concepts and details in [Reference](../reference/_index.md)
