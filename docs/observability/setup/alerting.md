# Alerting
//TODO
By default, alerts are paused. The project is configured to easily send alerts to any Slack Webhook out of the box, but can be customized further. 
 
There are two sets of rules :

- Basic alerts using uptime. If over 5m or 6h, if it drops below a certain percentage uptime, send an alert
- Alerting on SLOs by using burn rates, for multi-window multi-rate alerts Google SRE - Prometheus Alerting: Turn SLOs into Alerts. 



## How to Enable Alerting

### Define a SLO
To enable the burn rate alerting feature, create prometheus recording rule file with the following contents.

```yaml
groups:
  - name:  slo-target-rules
    rules:
      - record: slo_target_over_30_days # (Dont change)
        expr: 0.95 # Mandatory - Specify the SLO you want to target, for example 0.95 for 95% uptime over 30 days
        labels:
          job: "probe-cogstack-availability" #Mandatory - name the job, which must match the job in the probe targets defined
```

In docker, mount the file in `site/prometheus/recording-rules/slo.yml`.

### Turn on alerting
- Enable/Disable alerts using environment variables 
- By default alerts will send to slack. Provide the env variable `SLACK_WEBHOOK_URL` to go there


## Configuration

Alerting is setup using Grafana Alerts. 
- To change where the alerts are sent: create and mount custom a custom contact point in `/etc/grafana/provisioning/alerting/custom-contact.yml`. Then change the environment variable `ALERTING_DEFAULT_CONTACT` to use that name
- Add custom alerts by mounting alert files in `/etc/grafana/provisioning/alerting/`.

For more info see [Grafana Provisioning](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/)

See [Google SRE Guide](https://sre.google/workbook/alerting-on-slos/#4-alert-on-burn-rate) which explains burn rate alerting. The alerting setup here follows the recommendations in the SRE handbook for Multiwindow, Multiburn rate alerting.