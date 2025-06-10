#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting deployment test..."

# Run the quickstart script
echo "📦 Running quickstart..."
cd ${SCRIPT_DIR}/../examples/full/
bash ./full-quickstart.sh

# Run the health check
echo "🔍 Running health check..."
python -u ../../test/health-check.py

# Check if health check was successful
if [ $? -eq 0 ]; then
    echo "✅ Success! All services are running."
    docker compose down
    exit 0
else
    echo "❌ Health check failed."
    exit 1
fi

