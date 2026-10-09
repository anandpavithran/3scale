oc apply -f all-in-one.yml
# Ingress host URL
oc get route keycloak-ingress -n keycloak -o jsonpath='{.spec.host}'

# Initial admin password
oc get secret keycloak-initial-admin -n keycloak -o jsonpath='{.data.password}' | base64 -d; echo
