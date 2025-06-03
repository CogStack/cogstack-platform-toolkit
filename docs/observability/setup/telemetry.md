# Telemetry
//TODO
We can get telemetry from our services and VMs displayed in our dashboards. This telemetry gives us things like memory usage, and running container versions.

Using telemetry lets us get feedback from the stack, diagnose problems, and predict issues before they occur.

## Prometheus Exporters
Prometheus gets metrics from "Exporters". These need to be run on each VM you want to get metrics from

Run these exporters on each virtual machine.

- Node Exporter: This gives host metrics eg disk usage, memory
- Elastic Search Exporter: Get ES metrics like index size
- CAdvisor: This gives docker metrics, eg what containers are running

 Then add the host and IPs into a yaml file in `scrape-configs/exporters/` to tell prometheus where to scrape.


## How to run Exporters

## Add Exporters to Prometheus
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