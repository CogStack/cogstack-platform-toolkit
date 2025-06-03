# Availability Probing



- `site/prometheus/scrape-configs/probers/*.yml`. 
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