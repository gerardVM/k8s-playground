{{- /*
Return the full name of the release with the chart name appended,
truncated to 63 characters to comply with Kubernetes name limits.
*/ -}}
{{- define "my-rest-api.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
Return the name of the chart
*/ -}}
{{- define "my-rest-api.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- /*
Return common labels for all resources
*/ -}}
{{- define "my-rest-api.labels" -}}
app.kubernetes.io/name: {{ include "my-rest-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
