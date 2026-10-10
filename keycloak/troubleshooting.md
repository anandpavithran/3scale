echo $TOKEN
   55   curl -X GET -k  -i -H "Authorization: Bearer $TOKEN" "https://test1-sso-prod1-3scale-apicast-staging.apps.lab.example.com:443/" 
   56  echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null | jq .
   57  TOKEN=$(curl -X POST "http://keycloak-service-keycloak.apps.lab.example.com/realms/3scale/protocol/openid-connect/token"   -H "Content-Type: application/x-www-form-urlencoded"   -d "grant_type=client_credentials"   -d "client_id=6b322a56"   -d "client_secret=d434410ed45759d2b441fb4faf103a0e" | jq -r .access_token)
   58  echo $TOKEN

