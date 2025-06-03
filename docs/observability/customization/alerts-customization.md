# Alerts Customization

You can further setup and customize alerts in the stack.

## Customize Alert Contact points
If you want alerts to go to a different contact, for example an Email address instead of slack, you can customize where alerts are sent by defining a new contact point in Grafana:

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

## Add Custom Alerts
You can make custom alerts.

To define additional alert rules, create files in:

```
/etc/grafana/provisioning/alerting/
```

Grafana will automatically load these at startup.

---

