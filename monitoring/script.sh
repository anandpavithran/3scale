#!/bin/bash
CA_DATA=$(oc get configmap thanos-service-ca -n 3scale -o jsonpath='{.data.service-ca\.crt}')

cat <<EOF | oc apply -n 3scale -f -
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: grafanadatasource-sample
  namespace: 3scale
spec:
  allowCrossNamespaceImport: true
  datasource:
    name: Prometheus
    type: prometheus
    access: proxy
    isDefault: true
    url: https://thanos-querier.openshift-monitoring.svc:9091
    jsonData:
      httpHeaderName1: 'Authorization'
      timeInterval: 5s
      tlsSkipVerify: true
      tlsCACert: |
$(echo "${CA_DATA}" | sed 's/^/        /')
    secureJsonData:
      httpHeaderValue1: "Bearer $(oc create token $(oc get deployment grafana-deployment -n 3scale -o jsonpath='{.spec.template.spec.serviceAccountName}') -n 3scale --duration=8760h)"
  instanceSelector:
    matchLabels:
      app: 3scale-api-management
EOF
