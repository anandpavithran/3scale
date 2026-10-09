#!/bin/bash
oc apply -f ns.yml
oc apply -f np.yml -n dev-mailserver
oc apply -f dep.yml -n dev-mailserver
oc apply -f svc.yml -n dev-mailserver
oc create route edge mailserver-ui --service=mailserver-svc  --port=http-ui --namespace=dev-mailserver
oc patch secret system-smtp -p '{
  "stringData": {
    "address": "mailserver-svc.dev-mailserver.svc.cluster.local",
    "port": "1025",
    "domain": "mycompany.com",
    "authentication": "",
    "username": "",
    "password": "",
    "openssl_verify_mode": "none",
    "enable_starttls_auto": "false"
  }
}' -n 3scale
oc rollout restart deployment/system-sidekiq -n 3scale
oc rollout restart deployment/system-app -n 3scale
sleep 60
oc get pod
oc port-forward deployment/mailserver 8025:8025 -n dev-mailserver &
