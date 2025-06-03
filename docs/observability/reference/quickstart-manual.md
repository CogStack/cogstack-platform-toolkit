# Manual Quickstart
//TODO
The quickstart page uses a script to setup the folders for you.

This page instead details how to do it manually, to provide clarity.

## Step 1: Setup directory
Create the necessary directory structure
```
mkdir -p observability-simple/prometheus/scrape-configs/probers
mkdir -p observability-simple/prometheus/scrape-configs/exporters
```
 Something
 

Download these two files from github, and place in the right folder

- [docker-compose.yml](https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/docker-compose.yml) in observability-simple/
- [prometheus/scrape-configs/probers/probe-simple.yml](https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/prometheus/scrape-configs/probers/probe-simple.yml)

### Step 2: Start the stack

In the folder containing the downloaded files, run:

```bash
docker compose up -d
```

### Step 3: Access the dashboards
Open your web browser and go to:

`localhost/grafana`

You should see the Grafana dashboard displaying the availability of the sample web page.

There it is, you can now see the availability of the cogstack homepage, as well as the observability stack
