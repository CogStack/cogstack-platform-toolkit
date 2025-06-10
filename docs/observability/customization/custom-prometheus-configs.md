# Custom Prometheus Configuration

Prometheus can be fully customized, still using the provided defaults. To do this you can mount files in the right directories in docker. 

## Custom Prometheus Exporters

Grafana Alloy is used by default in the stack to get metrics for telemetry. If desired, it is also possible to get metrics by having prometheus scrape APIs

To do this, add the host and IPs into a yaml file in `prometheus/scrape-configs/exporters/` to tell prometheus where to scrape.

Mount these files under `site/prometheus/scrape-configs/exporters/*.yml` in docker


### Add Exporters to Prometheus
- `prometheus/scrape-configs/exporters/`
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

Note that this project is setup to run Grafana Alloy to push metrics from individual VMs. The config in `prometheus/scrape-configs/exporters/` is an alternative way, allowing you to pull metrics from any other services.

## Custom Prometheus Scrape Configs

You can add compeltely custom prometheus scrape configs and recording rules by mounting in docker.

- `site/prometheus/scrape-configs/*.yml`. This is for advanced configuration. 

Any yml file put in this directory will be used as standard promethues scrape configs. This will give full flexibility over what metrics are collected and all features in prometheus. Add any further configs that you want prometheus to use.

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
