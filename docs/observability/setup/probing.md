# Availability

This guide explains how to configure HTTP probers using Blackbox Exporter to monitor the availability of your services. These probers generate uptime and latency metrics, which can then be visualized in Grafana.

See the [Reference](../reference/understanding-metrics.md) for an explanation of the metrics this generates.

---

## How to Add New Probers

To add a new prober target:

1. Navigate to the folder:

   ```
    prometheus/scrape-configs/probers/
   ```

2. Create a new YAML file (e.g., `probe.my-services.yml`) with the following structure:

   ```
    # probe.my-services.yml
    - targets:
        - https://myservice.example.com/health
      labels:
        name: my-service             # Mandatory - the name of the service being probed
        job: my-services             # Mandatory - used to group probes in dashboards
        ip_address: "10.0.0.12"      # Optional - IP of the host being probed
        host: service-hostname       # Optional - Human-readable hostname
        region: eu-west              # Optional - Any additional metadata label
   ```

3. Ensure the folder is mounted in docker under `/etc/prometheus/cogstack/site/prometheus/scrape-configs/probers`, which it should be by default if you've followed the setup guids. Any valid `.yml` files in this folder will be automatically picked up and used as Blackbox targets.

---

## Advanced Setup

### How to add Auth to the prober or further configurations

To define how a probe behaves (e.g., add basic auth, headers, timeout, method), we will configure a module in the Blackbox Exporter config.

#### Create a Blackbox Exporter Config file
You will need to create a new file, and then mount it over the existing provided vconfig


1. Create a new file:

   ```
    prometheus/blackbox-exporter/custom-blackbox-config.yml
   ```

2. Add the existing defaults

```  
modules:
    http_get_200:
        prober: http
        timeout: 5s
        http:
        valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
        valid_status_codes: [200]  # Defaults to 2xx
        method: GET
        preferred_ip_protocol: "ip4" # defaults to "ip6"
        tls_config:
            insecure_skip_verify: true
```

3. Add your own module to the modules in that file
```
  http_2xx_custom:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: [200]  # Defaults to 2xx
      method: GET
      preferred_ip_protocol: "ip4" # defaults to "ip6"
      tls_config:
        insecure_skip_verify: true
      basic_auth:
        username: my-user
        password: example-pass
```

This example adds a module named `http_2xx_custom` that adds some basic auth credentials

---

#### Reference the new module in your prober config

In your probe YAML file, reference the module in the `module` field of the `labels` section:

```
    - targets:
        - https://myservice.example.com/health
      labels:
        name: my-service
        module: http_2xx_custom      # Optional - overrides the default Blackbox module
```

#### Mount the config file
You lastly need to mount the new config file and refer to it in docker compose

```
  blackbox-exporter:
    image: cogstacksystems/cogstack-observability-blackbox-exporter:latest
    restart: unless-stopped
    networks:
      - observability
    volumes:
      - ./prometheus/blackbox-exporter:/config
    command:
      - "--config.file=/config/custom-blackbox-config.yml" 
```

---

## Notes

* Changes will take effect on the next Prometheus reload or container restart.
* Jobs with the same `job` label are grouped in dashboards to simplify analysis.
* Job labels need to line up with defined SLOs to enable Alerting
* Probers can be used for both external URLs, and direct to local docker containers. For example, we probe grafana on "cogstack-observability-grafana-1:3000/". If you want to probe local docker containers, note that the network has to line up


## External links
For full Blackbox Exporter documentation, see:

- [Prometheus Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)
