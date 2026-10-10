#!/bin/bash
TOKEN=$(curl -X POST "http://keycloak-service-keycloak.apps.lab.example.com/realms/3scale/protocol/openid-connect/token"   -H "Content-Type: application/x-www-form-urlencoded"   -d "grant_type=client_credentials"   -d "client_id=zync-client"   -d "client_secret=0ZbR7KPJKfo7eUiX7Cme69dyshEdLkpk" | jq -r .access_token)
