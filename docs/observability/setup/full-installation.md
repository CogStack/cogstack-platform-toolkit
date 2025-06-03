# Production Setup
//TODO

This page shows how to setup the stack for a production deployment.

If you havent already done it, do see the quickstart tutorial


## Run the Observability Stack using Docker Compose

See the /examples folder for a working example of running this

To setup the stack for your deployment:
1. Create prometheus configurations as listed below
1. Copy this docker-compose.yml file
1. Mount your site config files into `/etc/prometheus/cogstack/site` 
1. Run with docker compose

To collect metrics from VMs to fill out the dashboards
- Run the Exporters on each VM as detailed below


## Prometheus Configurations

Prometheus is preconfigured with rules and configs, though needs additional site specific configs to scrape your stack. For example, it needs to be told exactly what hostname and port elasticsearch is running on, in order to check availability. 

This is managed through using different prometheus configuration files, which include different scrape config files.

Prometheus is used to get metrics from targets. It can target anything exporting metrics.

To use this project, you need to define your own targets in yml files and mount in docker following this folder structure:

```
  site/
    scrape-configs/exporters/*.yml
    scrape-configs/probers/*.yml
    scrape-configs/*.yml
    recording-rules/*yml
```

Note that all the URLs need to be accessible from the host running prometheus


