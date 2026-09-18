{{- define "ncai.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ncai.labels" -}}
app.kubernetes.io/name: {{ include "ncai.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "ncai.secretName" -}}
{{- if .Values.secrets.existingSecret -}}
{{- required "secrets.existingSecretName is required when secrets.existingSecret is true" .Values.secrets.existingSecretName -}}
{{- else -}}
ncai-gateway-secrets
{{- end -}}
{{- end -}}

{{/*
Build DATABASE_URL. An explicit databaseUrl wins; otherwise assemble one from
the discrete postgres.* values. When the password comes from an existing
secret we leave it out here and inject POSTGRES_PASSWORD separately, letting
the app compose the URL itself.
*/}}
{{- define "ncai.databaseUrl" -}}
{{- if .Values.secrets.databaseUrl -}}
{{- .Values.secrets.databaseUrl -}}
{{- end -}}
{{- end -}}
