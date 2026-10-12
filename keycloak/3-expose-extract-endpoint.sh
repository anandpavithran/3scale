#!/bin/bash
oc expose svc keycloak-service -n keycloak
oc get route -n keycloak
oc extract secret/keycloak-initial-admin --to=- -n keycloak
