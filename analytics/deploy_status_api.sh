#!/usr/bin/env bash
set -euo pipefail

# Configuration
NAMESPACE="${1:-status-backend}"
APP_NAME="status-api"
WORK_DIR="./${APP_NAME}-workspace"

echo "=========================================================="
echo " Starting standalone deployment for: ${APP_NAME}"
echo " Target Namespace: ${NAMESPACE}"
echo "=========================================================="

# 1. Check prerequisites
if ! command -v oc &>/dev/null; then
  echo "Error: 'oc' CLI client is not installed or not in PATH."
  exit 1
fi

if ! oc whoami &>/dev/null; then
  echo "Error: You are not logged into an OpenShift cluster. Please run 'oc login' first."
  exit 1
fi

# 2. Scaffold workspace directory
echo "[1/6] Generating microservice source code..."
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

# app.py
cat << 'EOF' > app.py
import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods=['GET'])
def root():
    return jsonify({"message": "Status API running"}), 200

@app.route('/status/<int:code>', methods=['GET'])
def return_status(code):
    valid_codes = [200, 201, 203, 400, 403, 404, 500, 503]
    if code not in valid_codes:
        return jsonify({"error": f"Unsupported test status code: {code}"}), 400
    
    return jsonify({
        "status": code,
        "description": f"HTTP response code {code} triggered successfully"
    }), code

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
EOF

# requirements.txt
cat << 'EOF' > requirements.txt
Flask>=3.0.0
gunicorn>=21.2.0
EOF

# Dockerfile
cat << 'EOF' > Dockerfile
FROM registry.access.redhat.com/ubi9/python-39:latest

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
EOF

# 3. Create or switch to OpenShift namespace
echo "[2/6] Configuring OpenShift project namespace: ${NAMESPACE}..."
if oc get project "${NAMESPACE}" &>/dev/null; then
  oc project "${NAMESPACE}"
else
  oc new-project "${NAMESPACE}"
fi

# 4. Set up binary BuildConfig and start build
echo "[3/6] Creating build configuration and pushing code..."
if ! oc get bc "${APP_NAME}" &>/dev/null; then
  oc new-build --strategy=docker --binary --name="${APP_NAME}"
fi

oc start-build "${APP_NAME}" --from-dir=. --follow

# 5. Create deployment, service, and route
echo "[4/6] Creating Deployment, Service, and Route..."
if ! oc get dc "${APP_NAME}" &>/dev/null && ! oc get deployment "${APP_NAME}" &>/dev/null; then
  oc new-app "${APP_NAME}"
fi

if ! oc get route "${APP_NAME}" &>/dev/null; then
  oc expose svc/"${APP_NAME}"
fi

# Wait for rollout
echo "[5/6] Waiting for deployment to roll out..."
oc rollout status deployment/"${APP_NAME}" || oc rollout status dc/"${APP_NAME}"

# 6. Retrieve Route and run self-test
echo "[6/6] Verifying deployed backend..."
ROUTE_HOST=$(oc get route "${APP_NAME}" -o jsonpath='{.spec.host}')
BACKEND_URL="http://${ROUTE_HOST}"

echo "Route exposed at: ${BACKEND_URL}"
echo "Sending test request to ${BACKEND_URL}/status/203..."

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/status/203")

if [ "${HTTP_CODE}" -eq 203 ]; then
  echo "✔ Verification successful! Received expected HTTP status: 203"
else
  echo "⚠ Warning: Received unexpected HTTP status: ${HTTP_CODE}"
fi

# Clean up workspace folder
cd ..
rm -rf "${WORK_DIR}"

echo ""
echo "=========================================================="
echo " DEPLOYMENT COMPLETE"
echo " Use the following as your 3scale Backend Private Base URL:"
echo " ${BACKEND_URL}"
echo "=========================================================="
