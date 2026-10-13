#!/bin/bash
#TOKEN=$(curl -X POST "http://keycloak-service-keycloak.apps.lab.example.com/realms/3scale/protocol/openid-connect/token"   -H "Content-Type: application/x-www-form-urlencoded"   -d "grant_type=client_credentials"   -d "client_id=fdfac608"   -d "client_secret=143d59771871e9b07253640317a2e23a" | jq -r .access_token)
#echo $TOKEN
#curl -k -i -H "Authorization: Bearer $TOKEN" "https://infosys-prod-3scale-apicast-staging.apps.lab.example.com:443/"

CLIENT_ID="54d68b80"
CLIENT_SECRET="3e0c0a2e5d4cb07da65b597405e3ec40"
GATEWAY_URL="https://infosys-prod-3scale-apicast-staging.apps.lab.example.com:443"

# 1. Request access token from Keycloak Token Endpoint
TOKEN=$(curl -k -s -X POST "http://keycloak-service-keycloak.apps.lab.example.com/realms/3scale/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" | jq -r .access_token)

echo "Retrieved Access Token: ${TOKEN}"

# 2. Invoke APIcast Gateway with Bearer Token
curl -k -i -H "Authorization: Bearer ${TOKEN}" "${GATEWAY_URL}/"
