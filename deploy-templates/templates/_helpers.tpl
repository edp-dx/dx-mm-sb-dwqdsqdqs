{{/*
Expand the name of the chart.
*/}}
{{- define "mm-sb-dwqdsqdqs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mm-sb-dwqdsqdqs.fullname" -}}
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
{{- define "mm-sb-dwqdsqdqs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mm-sb-dwqdsqdqs.labels" -}}
helm.sh/chart: {{ include "mm-sb-dwqdsqdqs.chart" . }}
{{ include "mm-sb-dwqdsqdqs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mm-sb-dwqdsqdqs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mm-sb-dwqdsqdqs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mm-sb-dwqdsqdqs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mm-sb-dwqdsqdqs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress
*/}}
{{- define "mm-sb-dwqdsqdqs.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "mm-sb-dwqdsqdqs.ingress.isStable" -}}
  {{- eq (include "mm-sb-dwqdsqdqs.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "mm-sb-dwqdsqdqs.ingress.supportsIngressClassName" -}}
  {{- or (eq (include "mm-sb-dwqdsqdqs.ingress.isStable" .) "true") (and (eq (include "mm-sb-dwqdsqdqs.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "mm-sb-dwqdsqdqs.ingress.supportsPathType" -}}
  {{- or (eq (include "mm-sb-dwqdsqdqs.ingress.isStable" .) "true") (and (eq (include "mm-sb-dwqdsqdqs.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}