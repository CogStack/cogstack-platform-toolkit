# Telemetry

We can get telemetry from our services and VMs displayed in our dashboards. This telemetry gives us things like memory usage, and running container versions.

Using telemetry lets us get feedback from the stack, diagnose problems, and predict issues before they occur.

Grafana Alloy is used to get telemetry. These features are configured by default in this project inside the created image

- Node Exporter: This gives host metrics eg disk usage, memory
- Elastic Search Exporter: Get ES metrics like index size
- CAdvisor: This gives docker metrics, eg what containers are running

## How to get Telemetry

- Copy this docker compose file: (exporters.docker-compose.yml)[observability/examples/full/exporters.docker-compose.yml]
- Edit the environment variables to point to your prometheus URL
- Run `docker compose -f exporters.docker-compose.yml up -d ` on every VM you want metrics from
