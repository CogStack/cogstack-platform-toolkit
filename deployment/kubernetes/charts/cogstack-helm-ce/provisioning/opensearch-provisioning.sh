#!/usr/bin/env bash
# Apply base_index_settings.json as index template. Run from this directory.
# See: https://docs.opensearch.org/latest/im-plugin/index-templates/
#!/usr/bin/env bash
log() {
    local ts
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$ts] $*"
}

#: "${OPENSEARCH_URL:?OPENSEARCH_URL is required. Include scheme, port and /api eg http://localhost:9200/ }"
#: "${OPENSEARCH_DASHBOARD_URL:?OPENSEARCH_DASHBOARD_URL is required. Include scheme, port and /api eg http://localhost:5601/api }"

OPENSEARCH_URL=https://localhost:9200
OPENSEARCH_DASHBOARD_URL=http://localhost:5601

wait_for_service() {
    local service_name="$1"
    local url="$2"
    local curl_extra_args="${3:-}"
    local max_wait=120
    local interval=2
    local elapsed=0

    while true; do
        if curl -sf --insecure $curl_extra_args "$url" >/dev/null; then
            log "$service_name is running ✅"
            return 0
        else
            log "$service_name is not running at $url ❌"
            if [ "$elapsed" -ge "$max_wait" ]; then
                log "Timed out waiting for $service_name to become healthy"
                return 1
            fi
            log "Retrying in $interval seconds..."
            sleep "$interval"
            elapsed=$((elapsed + interval))
            interval=$(( interval * 2 ))
            if [ "$interval" -gt 10 ]; then
                interval=10
            fi
        fi
    done
}
wait_for_service "OpenSearch Dashboard" "$OPENSEARCH_DASHBOARD_URL" || exit 1
wait_for_service "OpenSearch" "$OPENSEARCH_URL" '-u admin:opensearch-312$A' || exit 1

log "Creating index template"
curl -X PUT "https://localhost:9200/_index_template/base_index_template" -H "Content-Type: application/json" -u 'admin:opensearch-312$A' -k -d @base_index_settings.json

log "Creating example admissions document"
curl -X POST "https://localhost:9200/admissions/_doc" -H "Content-Type: application/json" -u 'admin:opensearch-312$A' -k -d '{
  "subject_id": 10000032,
  "hadm_id": 22595853,
  "admittime": "2180-05-06 22:23:00",
  "dischtime": "2180-05-07 17:15:00",
  "admission_type": "URGENT",
  "admit_provider_id": "P49AFC",
  "admission_location": "TRANSFER FROM HOSPITAL",
  "discharge_location": "HOME",
  "insurance": "Medicaid",
  "language": "English",
  "marital_status": "WIDOWED",
  "race": "WHITE",
  "edregtime": "2180-05-06 19:17:00",
  "edouttime": "2180-05-06 23:30:00",
  "hospital_expire_flag": 0
}'

log "Importing dashboards"
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" -H "osd-xsrf: true" --form file=@dashboards.ndjson -u 'admin:opensearch-312$A' --insecure