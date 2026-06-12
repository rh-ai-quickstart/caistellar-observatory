{{/*
Expand the name of the chart.
*/}}
{{- define "caistellar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "caistellar.fullname" -}}
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
{{- define "caistellar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "caistellar.labels" -}}
helm.sh/chart: {{ include "caistellar.chart" . }}
{{ include "caistellar.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "caistellar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "caistellar.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Model endpoint URL
*/}}
{{- define "caistellar.modelEndpoint" -}}
{{- $namespace := .Values.model.namespace | default .Release.Namespace -}}
{{- $serviceName := .Values.model.serviceName | default (printf "%s-predictor" .Values.model.name) -}}
http://{{ $serviceName }}.{{ $namespace }}.svc.cluster.local:{{ .Values.model.port }}/v2/models/{{ .Values.model.name }}/infer
{{- end }}
