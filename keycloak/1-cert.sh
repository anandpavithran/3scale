#!/bin/bash
openssl req -x509 -newkey rsa:2048 -keyout tls.key -out tls.crt -days 365 -nodes -subj "/CN=keycloak"
oc create secret tls keycloak-tls-secret --cert=tls.crt --key=tls.key
