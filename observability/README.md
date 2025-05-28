# Cogstack Observability Stack

This project runs a stack for observability of deployed software.

It provides the following features:
- Dashboards for availability
- Telemetry of infrastructure such as host memory usage, and elasticsearch index size
- Alerting based on a defined Service Level Objective (SLO) and burn rates
- Blackbox Probing of services to find service level indicators of uptime and latency
- A working inventory of what is running where

## Usage Guide

The stack runs grafana with a set of dashboards. 
Access Grafana on `http://your-ip/grafana`

### Grafana Dashboards
- Availability
- Elasticsearch
- VM Metrics (Memory use, CPU etc)
- Docker Metrics (Running containers)

### Alerting
The alerts are paused by default.

Alerting is based on either pure availability on 5 minutes or 6 hours, as well as a burn rate implementation. 

See [Google SRE Guide](https://sre.google/workbook/alerting-on-slos/#4-alert-on-burn-rate) which explains burn rate alerting. The alerting setup here follows the recommendations in the SRE handbook for Multiwindow, Multiburn rate alerting.

For burn rate alerting, ensure that a recording rule is setup to create a record for `slo_target_over_30_days`, with a job label that matches your probe job labels. See the prometheus readme in this project. 

## How to Run the stack

See the /examples folder for a working example of running this

To setup the stack for your deployment:
- Create prometheus configurations as listed below
- Copy this docker-compose.yml file
- Mount your site config files into `/etc/prometheus/cogstack/site` 
- Run with docker compose

To collect metrics from VMs to fill out the dashboards
- Run the Exporters on each VM as detailed below


## Grafana Configuration

Grafana is setup with preconfigured dashboards, datasource, and alerting. These will work when prometheus is run in this stack, and is dependent on all the metrics following defined rules. 

It is advised that any edits or new configs get committed back into your git repository, and stick with grafana provisioning instead of allowing manual edits

### Customise grafana

#### Dashboards
- Mount new dashboard files in the `/etc/grafana/provisioning/dashboards/site` directory
- To remove or change the existing, then mount over the existing files there

For more info see [Grafana Alerting Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards)

#### Alerting
- Enable/Disable alerts using environment variables 
- By default alerts will send to slack. Provide the env variable `SLACK_WEBHOOK_URL` to go there
- To change where the alerts are sent: create and mount custom a custom contact point in `/etc/grafana/provisioning/alerting/custom-contact.yml`. Then change the environment variable `ALERTING_DEFAULT_CONTACT` to use that name
- Add custom alerts by mounting alert files in `/etc/grafana/provisioning/alerting/`.

For more info see [Grafana Provisioning](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/)


## Prometheus Configurations

Prometheus is preconfigured with rules and configs, though needs additional site specific configs to scrape your stack. For example, it needs to be told exactly what hostname and port elasticsearch is running on, in order to check availability. 

This is managed through using different prometheus configuration files, which include different scrape config files.

### Prometheus Site Configurations

Prometheus is used to get metrics from targets. It can target anything exporting metrics.

To use this project, you need to define your own targets in yml files and mount in docker following this folder structure:
```
  site/
    /scrape-configs/exporters/*.yml
    /scrape-configs/probers/*.yml
    /scrape-configs/*.yml
    /recording-rules/*yml
```

There are 3 ways to add targets to prometheus in this project:

- `scrape-configs/probers/*.yml`. 
Add yaml files to this folder as probe targets. Any yml files put into this directory, for example "probe.example.yml", will be used as targets to probe for availability using blackbox exporter. Add any URLs that you want to measure the availability of. 

```yaml 
# Prober yml
- targets:
    - https://google.com/something
  labels:
    name: google-homepage # Mandatory - the name of the service being probed
    job: override_job # (Optional. Default is "probe-cogstack-availability") Customise a job to enable grouping in the dashboard
    ip_address: "123.0.0.1" # (Optional) The IP address
    host: a_hostname # (Optional) A readable hostname
    custom_label: a_custom_label # (Optional)  Any other label
    
```
Note that URLs need to be accessible from the host running prometheus

- `scrape-configs/exporters/` -
 Add yaml files into this folder. These file should contain all exporter prometheus metrics, for example from node_exporter or CAdvisor. Add any hosts and ip addresses you want to collect /metrics from will be retrieved

```yaml 
# Exporter example yml
- targets:
    - 123.0.0.1:9100 # Enter your IP address and port of a target
  labels:
    job: node_exporter # Mandatory  - Enter the type of metric being collected
    host: my-host-name  # (Optional) A readable hostname
    custom_label: a_custom_label # (Optional)
    # __metrics_path__: /path/metrics  # Optionally override the metrics path, the default is just /metrics
# ... add all targets
```

- `scrape-configs/*.yml`. This is for advanced configuration. Any yml file put in this directory will be used as standard promethues scrape configs. This will give full flexibility over what metrics are collected and all features in prometheus. Add any further configs that you want prometheus to use.

```yaml
# Custom scrape config definition
scrape_configs:
  - job_name: custom-scrape-config # Scrape configuration to get metrics from elasticsearch, eg index size.
    static_configs:
      - targets:
          - my-custom-target:9114
        labels:
          custom_label: custom # (Optional)
```

- `/recording-rules/*.yml`

Add recording rules in here.

To enable the burn rate alerting feature, you must include a recording rule file with the following contents. 

```yaml
groups:
  - name:  slo-target-rules
    rules:
      - record: slo_target_over_30_days # (Dont change)
        expr: 0.95 # Mandatory - Specify the SLO you want to target, for example 0.95 for 95% uptime over 30 days
        labels:
          job: "probe-cogstack-availability" #Mandatory - name the job, which must match the job in the probe targets defined
```

## Exporters

Prometheus gets metrics from "Exporters". These need to be run on each VM you want to get metrics from

Run these exporters on each virtual machine.

- Node Exporter: This gives host metrics eg disk usage, memory
- Elastic Search Exporter: Get ES metrics like index size
- CAdvisor: This gives docker metrics, eg what containers are running

 Then add the host and IPs into a yaml file in `scrape-configs/exporters/` to tell prometheus where to scrape.



## Local Development

Run the stack locally with
```
cd ./observability/examples/simple
docker compose up -d
```

This will start the observability stack, set to probe and monitor itself.
