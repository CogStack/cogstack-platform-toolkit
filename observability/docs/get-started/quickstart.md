## QuickStart

This tutorial guides you through running the simplest setup of the observability stack using example configuration files and Docker Compose.

After completing these steps, you will have a full observability stack running locally, showing the availability of web pages you want to target

### Requirements

- Docker installed ([install Docker](https://docs.docker.com/get-docker/))
- Docker Compose installed ([install Docker Compose](https://docs.docker.com/compose/install/))
- A terminal with network access

### Step 1: Run the Quickstart script

Run this quickstart script to setup the project
```bash
curl https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/quickstart.sh | bash
```
Now go to "http://localhost/grafana" to see the dashboards

Thats everything. The stack is running and you can see the availability.


### Optional Step: Probe your own web page
Now you can look at getting monitoring of your own page

In your current folder, edit the file `prometheus/scrape-configs/probers/probe-simple.yml` that you downloaded from git.

Add the following yml to the bottom of the file:

```yaml
- targets:
    - https://google.com
  labels:
    name: google
    job: probe-my-own-site
```


The change should get applied automatically, but if you dont want to wait then run
```
docker compose restart
```

Now refresh the grafana dashboard, and you can see the availability of google.com, it's probably 100%!


## Next steps
This is the end of this quickstart tutorial, that enables probing availability of endpoints.

For the next steps we can:
- Productionise our deployment to enable further features
- Enable *Telemetry* like VM memory usage, and Elasticsearch index size, by running Exporters
- Enable *Alerting* based on our availability and a defined Service Level Objective (SLO)
- Look further into the available dashboards
- Fully customize the stack with our own dashboards, recording rules and metrics





