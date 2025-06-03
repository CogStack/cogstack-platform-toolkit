# Alerting

This guide explains how to enable and customize alerting in the CogStack observability stack using Grafana and Prometheus.

By default, alerts are **paused**. The system is preconfigured to send alerts to a **Slack Webhook**, but this can be customized.

There are two categories of alerting:

* **Basic availability alerts**: Triggered when uptime falls below a threshold over short windows (5m or 6h).
* **Burn rate alerts**: Using multi-window multi-rate alerts following best practices in [Google SRE principles](https://sre.google/workbook/alerting-on-slos/), used to track compliance with SLOs.

---

## How to Enable Alerting

### 1. Define Your SLO

To configure burn rate alerting, create a Prometheus recording rule to define your target SLO:

```
groups:
  - name:  slo-target-rules
    rules:
      - record: slo_target_over_30_days
        expr: 0.95
        labels:
          job: "probe-services"
```

* `expr`: Target SLO (e.g., `0.95` for 95% over 30 days)
* `job`: Must match the probe job name defined in your configuration. This allows you to have different SLOs for different endpoints. 

Place this file at:

```
prometheus/recording-rules/slo.yml
```

This should be mounted in the docker container under `/etc/prometheus/cogstack/site/prometheus/recording-rules/slo.yml`, which should be already setup if you followed the setup instructions. 

---

### 2. Configure Alerting Environment

Set these environment variables to control alerting behavior:

```
ALERTING_PAUSE_AVAILABILITY_5M=true
ALERTING_PAUSE_AVAILABILITY_6H=true
ALERTING_PAUSE_BURN_RATE=true
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your-webhook
```

* Set any of the `ALERTING_PAUSE_*` variables to `false` to enable that alert type.
* `SLACK_WEBHOOK_URL` should be set to a webhook, which will send any alerts to slack. 

---

## Advanced Customization
### Customize Alert Contact points

You can customize where alerts are sent by defining a new contact point in Grafana:

```
notifiers:
  - name: "custom-contact"
    type: "slack"
    settings:
      url: "https://hooks.slack.com/services/..."
```

Mount this file into:

```
/etc/grafana/provisioning/alerting/custom-contact.yml
```

Then update the environment variable:

```
ALERTING_DEFAULT_CONTACT=custom-contact
```

**Note** to be only mount the exact file, and not override the whole provisioning folder in the image, as this is already used to contain the defaults. 

---

### Add Custom Alerts
To define additional alert rules, create files in:

```
/etc/grafana/provisioning/alerting/
```

Grafana will automatically load these at startup.

---

## Further Reading

* [Grafana Alerting Provisioning](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/)
* [Google SRE – Burn Rate Alerting](https://sre.google/workbook/alerting-on-slos/#4-alert-on-burn-rate)

Let me know if you'd like to split this into multiple focused guides, e.g., one for basic uptime, one for SLO-based alerts.
