#!/bin/bash
set -e

mkdir -p observability-simple/prometheus/scrape-configs/probers
mkdir -p observability-simple/prometheus/scrape-configs/exporters
cd observability-simple

echo "Downloading docker-compose.yml..."
curl -fsSL -o docker-compose.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/docker-compose.yml

echo "Downloading probe-simple.yml into prometheus/scrape-configs/probers/..."
curl -fsSL -o prometheus/scrape-configs/probers/probe-simple.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/prometheus/scrape-configs/probers/probe-simple.yml

echo "Downloading exporters-simple.yml into prometheus/scrape-configs/exporters/..."
curl -fsSL -o prometheus/scrape-configs/exporters/exporters-simple.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/refs/heads/main/observability/examples/simple/prometheus/scrape-configs/exporters/exporters-simple.yml

echo "Setup complete in observability-simple/"

echo "Starting the observability stack"
docker compose up -d

 echo "Please open http://localhost/grafana in your browser"