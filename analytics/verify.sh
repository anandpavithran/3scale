#!/bin/bash 
STAGING_HOST=status1-3scale-apicast-staging.apps.lab.example.com:443
USER_KEY=efa0d4f36813cd9a4fb43eca01a1f64b
echo "Making requests to staging gateway..."

# 7 requests returning 200
for i in {1..7}; do
  curl -k "https://${STAGING_HOST}/status/200?user_key=${USER_KEY}" 
done

# 8 requests returning 201
for i in {1..8}; do
  curl -k "https://${STAGING_HOST}/status/201?user_key=${USER_KEY}" 
done

# 5 requests returning 203
for i in {1..5}; do
  curl -k "https://${STAGING_HOST}/status/203?user_key=${USER_KEY}" 
done

echo "Requests completed: 20 total (7x 200, 8x 201, 5x 203)"
