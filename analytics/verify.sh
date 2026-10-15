#!/bin/bash
STAGING_HOST=
USER_KEY=
echo "Making requests to staging gateway..."

# 7 requests returning 200
for i in {1..7}; do
  curl -s -k "https://${STAGING_HOST}/status/200?user_key=${USER_KEY}" > /dev/null
done

# 8 requests returning 201
for i in {1..8}; do
  curl -s -k "https://${STAGING_HOST}/status/201?user_key=${USER_KEY}" > /dev/null
done

# 5 requests returning 203
for i in {1..5}; do
  curl -s -k "https://${STAGING_HOST}/status/203?user_key=${USER_KEY}" > /dev/null
done

echo "Requests completed: 20 total (7x 200, 8x 201, 5x 203)"
