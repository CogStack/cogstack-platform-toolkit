#!/usr/bin/sh
set -e
log() {
    local ts
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$ts] $*"
}

: "${OPENSEARCH_URL:?OPENSEARCH_URL is required. Include scheme, port and /api eg http://localhost:9200/ }"
: "${OPENSEARCH_DASHBOARD_URL:?OPENSEARCH_DASHBOARD_URL is required. Include scheme, port and /api eg http://localhost:5601/api }"
: "${OPENSEARCH_USERNAME:?OPENSEARCH_USERNAME is required. }"
: "${OPENSEARCH_PASSWORD:?OPENSEARCH_PASSWORD is required. }"

: "${CONFIG_DIR:?CONFIG_DIR is required. }"
: "${CURL_BODY_FILE:=/tmp/curl_body.$$}"
# OPENSEARCH_URL=https://localhost:9200
# OPENSEARCH_DASHBOARD_URL=http://localhost:5601
# OPENSEARCH_USERNAME=admin
# OPENSEARCH_PASSWORD=opensearch-312$A

wait_for_service() {
    local service_name="$1"
    local url="$2"
    local curl_extra_args="${3:-}"
    local max_wait=120
    local interval=2
    local elapsed=0

    while true; do
        if curl -sf --insecure $curl_extra_args "$url" >/dev/null; then
            log "$service_name is running"
            return 0
        else
            log "$service_name is not running at $url"
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

OPENSEARCH_AUTH="$OPENSEARCH_USERNAME:$OPENSEARCH_PASSWORD"

if [ "$PROVISION_OPENSEARCH_INDEX_TEMPLATE_ENABLED" = "true" ]; then
    wait_for_service "OpenSearch" "$OPENSEARCH_URL" "-u $OPENSEARCH_AUTH" || exit 1
    # See: https://docs.opensearch.org/latest/im-plugin/index-templates/
    log "Creating index template - PUT $OPENSEARCH_URL/_index_template/base_index_template"
    os_status="$(curl -sS \
        -o "$CURL_BODY_FILE" \
        -w "%{http_code}" \
        -X PUT "$OPENSEARCH_URL/_index_template/base_index_template" \
        -H "Content-Type: application/json" \
        -u "$OPENSEARCH_AUTH" \
        -k \
        -d @"${CONFIG_DIR}/base_index_settings.json")"
    if [ "$os_status" != "200" ] && [ "$os_status" != "201" ]; then
        log "Failed to create index template (http_status=$os_status)"
        if [ -s "$CURL_BODY_FILE" ]; then
            log "Response body:"
            sed 's/^/  /' "$CURL_BODY_FILE"
        fi
        exit 1
    fi
fi

if [ "$PROVISION_OPENSEARCH_EXAMPLE_DOCUMENTS_ENABLED" = "true" ]; then
    wait_for_service "OpenSearch" "$OPENSEARCH_URL" "-u $OPENSEARCH_AUTH" || exit 1
    log "Creating example admissions document - POST $OPENSEARCH_URL/admissions/_doc"
    os_status="$(curl -sS \
        -o "$CURL_BODY_FILE" \
        -w "%{http_code}" \
        -X POST "$OPENSEARCH_URL/admissions/_doc" \
        -H "Content-Type: application/json" \
        -u "$OPENSEARCH_AUTH" \
        -k \
        -d '{
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
}')"
    if [ "$os_status" != "200" ] && [ "$os_status" != "201" ]; then
        log "Failed to create example admissions document (http_status=$os_status)"
        if [ -s "$CURL_BODY_FILE" ]; then
            log "Response body:"
            sed 's/^/  /' "$CURL_BODY_FILE"
        fi
        exit 1
    fi
fi

if [ "$PROVISION_OPENSEARCH_DASHBOARDS_ENABLED" = "true" ]; then
    log "Provisioning OpenSearch Dashboards"
    wait_for_service "OpenSearch Dashboard" "$OPENSEARCH_DASHBOARD_URL" || exit 1

    log "Importing dashboards - POST $OPENSEARCH_DASHBOARD_URL/api/saved_objects/_import?overwrite=true"
    osd_status="$(curl -sS \
        -o "$CURL_BODY_FILE" \
        -w "%{http_code}" \
        -X POST "$OPENSEARCH_DASHBOARD_URL/api/saved_objects/_import?overwrite=true" \
        -H "osd-xsrf: true" \
        --form "file=@${CONFIG_DIR}/dashboards.ndjson" \
        -u "$OPENSEARCH_AUTH" \
        --insecure)"
    if [ "$osd_status" != "200" ] && [ "$osd_status" != "201" ]; then
        log "Failed to import dashboards (http_status=$osd_status)"
        if [ -s "$CURL_BODY_FILE" ]; then
            log "Response body:"
            sed 's/^/  /' "$CURL_BODY_FILE"
        fi
        exit 1
    fi
fi

log "Provisioning completed"