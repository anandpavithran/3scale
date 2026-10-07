#!/bin/bash
GATEWAY_URL="https://bookstore-api-system1-3scale-apicast-production.apps.lab.example.com:443"

echo "=========================================================="
echo "TEST 1: UN-AUTHENTICATED PATH ACCESS (NO USER_KEY PROVIDED)"
echo "=========================================================="
# Notice: Neither user_key query parameter nor auth headers are sent!
 curl -k -i -s "${GATEWAY_URL}/v1/books"
 echo -e "\n"

 echo "=========================================================="
 echo "TEST 2: UN-AUTHENTICATED HEADER VERSIONING WITH ANONYMOUS"
 echo "=========================================================="
 curl -k -i -s -H "X-API-Version: 2" "${GATEWAY_URL}/books"
 echo -e "\n"
