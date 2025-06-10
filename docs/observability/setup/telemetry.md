# Telemetry

We can get telemetry from our services and VMs displayed in our dashboards. This telemetry gives us things like memory usage, and running container versions.

Using telemetry lets us get feedback from the stack, diagnose problems, and predict issues before they occur.

Grafana Alloy is used to get telemetry. These features are configured by default in this project inside the created image

- Node Exporter: This gives host metrics eg disk usage, memory
- Elastic Search Exporter: Get ES metrics like index size
- CAdvisor: This gives docker metrics, eg what containers are running

## How to get Telemetry

- Copy this docker compose file: [exporters.docker-compose.yml](../../../observability/examples/full/exporters.docker-compose.yml)
- Edit the environment variables to point to your prometheus URL
- Run `docker compose -f exporters.docker-compose.yml up -d ` on every VM you want metrics from


### Elastic Search Metrics
To get elasticsearch metrics we have to mount an alloy config file into the image.

- Copy this docker compose file: [exporters.elastic.docker-compose.yml](../../../observability/examples/full/exporters.elastic.docker-compose.yml)
- Copy this configuration file [elasticsearch.alloy](../../../observability/examples/full/alloy/elasticsearch.alloy) into `alloy/elasticsearch.alloy`

In the docker compose file, we can see there are two changes to the usual exporter:

```yaml
    volumes:
      - ${BASE_DIR-.}/alloy/elasticsearch.alloy:/etc/alloy/elasticsearch.alloy # Enable Elastic Exporter
      ...
    environment:    
      - ELASTICSEARCH_URL=${ELASTICSEARCH_URL-https://elasticsearch-1:9200}
      - ELASTICSEARCH_USERNAME=${ELASTICSEARCH_USERNAME-user} # Used to get metrics from Elasticsearch
      - ELASTICSEARCH_PASSWORD=${ELASTICSEARCH_PASSWORD-pass} # Used to get metrics from Elasticsearch
```

By adding the alloy config file, and the elasticsearch environment details, Alloy will run and get metrics from elasticsearch.

This pattern can be used to customize grafana alloy fully: mount any config files you want to in `/etc/alloy` and it will read them.

## Next Steps
- You can fully customise Grafana Alloy by mounting your own alloy config files