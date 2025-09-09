{{/*
Expand the name of the chart.
*/}}
{{- define "medcat-trainer-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "medcat-trainer-helm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "medcat-trainer-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "medcat-trainer-helm.labels" -}}
helm.sh/chart: {{ include "medcat-trainer-helm.chart" . }}
{{ include "medcat-trainer-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: cogstack
{{- end }}

{{/*
Selector labels
*/}}
{{- define "medcat-trainer-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "medcat-trainer-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "medcat-trainer-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "medcat-trainer-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- /*
Return Solr host: either user-supplied or constructed from release name

TODO: Make Solr use the chart fullname instead of release name
*/ -}}
{{- define "medcat-trainer-helm.solrHost" -}}
{{- if .Values.solrHost }}
{{ .Values.solrHost }}
{{- else }}
{{- .Release.Name }}-solr
{{- end }}
{{- end }}

{{- /*
Return Solr port: either user-supplied or default from values
*/ -}}
{{- define "medcat-trainer-helm.solrPort" -}}
{{- if .Values.solrPort }}
{{ .Values.solrPort }}
{{- else }}
{{- .Values.solr.service.ports.http }}
{{- end }}
{{- end }}

{{- /*
Return full Solr URL: combines host and port
*/ -}}
{{- define "medcat-trainer-helm.solrURL" -}}
http://{{ include "medcat-trainer-helm.solrHost" . }}:{{ include "medcat-trainer-helm.solrPort" . }}
{{- end }}