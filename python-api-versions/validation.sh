#!/bin/bash
GATEWAY_URL="https://bookstore-api-system1-3scale-apicast-production.apps.lab.example.com:443"
USER_KEY="3b8142eefa745c12f437a5d81f425291"

echo "=============================================="
echo "TEST 1: URI PATH VERSIONING"
echo "=============================================="

echo "--- Invoking /v1/books ---"
curl -k -s "${GATEWAY_URL}/v1/books?user_key=${USER_KEY}"
echo -e "\n"

echo "--- Invoking /v2/books ---"
curl -k -s "${GATEWAY_URL}/v2/books?user_key=${USER_KEY}"
echo -e "\n"

echo "=============================================="
echo "TEST 2: HTTP HEADER VERSIONING (ROUTING POLICY)"
echo "=============================================="

echo "--- Invoking /books with Header X-API-Version: 1 ---"
curl -k -s -H "X-API-Version: 1" "${GATEWAY_URL}/books?user_key=${USER_KEY}"
echo -e "\n"

echo "--- Invoking /books with Header X-API-Version: 2 ---"
curl -k -s -H "X-API-Version: 2" "${GATEWAY_URL}/books?user_key=${USER_KEY}"
echo -e "\n"

