#!/bin/bash
oc apply -f ns.yml
oc apply -f dep.yml -n keycloak
sleep 60
