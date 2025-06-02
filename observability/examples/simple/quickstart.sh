#!/bin/bash
set -e

mkdir -p observability-stack/prometheus/scrape-configs/probers
cd observability-stack

echo "Downloading docker-compose.yml..."
curl -fsSL -o docker-compose.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/docker-compose.yml

echo "Downloading probe-simple.yml into prometheus/scrape-configs/probers/..."
curl -fsSL -o prometheus/scrape-configs/probers/probe-simple.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/prometheus/scrape-configs/probers/probe-simple.yml

echo "Setup complete in observability-stack/"
