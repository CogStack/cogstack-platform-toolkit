# Custom Prometheus Configuration
//TODO

You can add compeltely custom prometheus scrape configs and recording rules by mounting in docker.



- `site/prometheus/scrape-configs/*.yml`. This is for advanced configuration. Any yml file put in this directory will be used as standard promethues scrape configs. This will give full flexibility over what metrics are collected and all features in prometheus. Add any further configs that you want prometheus to use.

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