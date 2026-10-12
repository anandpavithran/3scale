#!/bin/bash
TOKEN=$(curl -X POST "http://keycloak-service-keycloak.apps.lab.example.com/realms/3scale/protocol/openid-connect/token"   -H "Content-Type: application/x-www-form-urlencoded"   -d "grant_type=client_credentials"   -d "client_id=fdfac608"   -d "client_secret=143d59771871e9b07253640317a2e23a" | jq -r .access_token)
echo $TOKEN
curl -k -i -H "Authorization: Bearer $TOKEN" "https://infosys-prod-3scale-apicast-staging.apps.lab.example.com:443/"
