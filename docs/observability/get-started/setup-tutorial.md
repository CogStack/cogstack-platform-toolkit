# Production Setup
This page shows how to setup the stack for production

## Run the Observability Stack using Docker Compose

See the /examples folder for a working example of running this

To setup the stack for your deployment:
- Create prometheus configurations as listed below
- Copy this docker-compose.yml file
- Mount your site config files into `/etc/prometheus/cogstack/site` 
- Run with docker compose

To collect metrics from VMs to fill out the dashboards
- Run the Exporters on each VM as detailed below