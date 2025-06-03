# Custom Dashboards
//TODO
Grafana is setup with preconfigured dashboards, datasource, and alerting. These will work when prometheus is run in this stack, and is dependent on all the metrics following defined rules. 

it is advised that any edits or new configs get committed back into your git repository, and stick with grafana provisioning instead of allowing manual edits


## How to add a new dashboard with provisioning 

- Mount new dashboard files in the `/etc/grafana/provisioning/dashboards/site` directory
- To remove or change the existing, mount over the existing files there

For more info see [Grafana Alerting Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards)

