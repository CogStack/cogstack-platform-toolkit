
#!/bin/bash
set -e
download_to() {
  local path="$1"
  local url="https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/full/${path}"

  echo "Downloading ${path} from ${url}"
  mkdir -p "$(dirname "$path")"
  curl -fsSL -o "$path" "$url"
}

mkdir -p cogstack-observability/prometheus/scrape-configs/probers
mkdir -p cogstack-observability/prometheus/scrape-configs/exporters
mkdir -p cogstack-observability/prometheus/scrape-configs/recording-rules
cd cogstack-observability

download_to docker-compose.yml
download_to exporters.docker-compose.yml
download_to exporters.elastic.docker-compose.yml

download_to prometheus/scrape-configs/probers/probe-internal.yml
download_to prometheus/scrape-configs/probers/probe-external.yml
download_to prometheus/scrape-configs/exporters/exporters.yml
download_to prometheus/scrape-configs/recording-rules/slo.yml


echo "Setup complete in cogstack-observability/"
