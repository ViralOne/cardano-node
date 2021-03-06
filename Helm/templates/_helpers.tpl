{{/*
Expand the name of the chart.
*/}}
{{- define "node-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node-chart.fullname" -}}
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
{{- define "node-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node-chart.labels" -}}
helm.sh/chart: {{ include "node-chart.chart" . }}
{{ include "node-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "node-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the cardano topology JSON config files
*/}}
{{- define "cardano.topologyJson" -}}
{{ $defaultProducers := list (dict "addr" "relays-new.cardano-testnet.iohkdev.io" "port" 3001 "valency" 1 "--testnet-magic" 1097911063) }}
{{ $producers := list }}
{{- if gt (len .Values.cardano.producers) 0 -}}
{{ $producers = concat $defaultProducers .Values.cardano.producers }}
{{- else -}}
{{ $producers = $defaultProducers }}
{{- end -}}
{{ toPrettyJson (dict "Producers" $producers) }}
{{- end -}}
