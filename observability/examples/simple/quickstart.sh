#!/bin/bash
set -e

mkdir -p observability-simple/alloy/probers
cd observability-simple

echo "Downloading docker-compose.yml..."
curl -fsSL -o docker-compose.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/docker-compose.yml

echo "Downloading probe-simple.yml into alloy/probers/..."
curl -fsSL -o probers/probe-observability.yml \
  https://raw.githubusercontent.com/CogStack/cogstack-platform-toolkit/main/observability/examples/simple/probers/probe-observability.yml

echo "Setup complete in observability-simple/"

echo "Starting the observability stack"
docker compose up -d

 echo "Please open http://localhost/grafana in your browser"