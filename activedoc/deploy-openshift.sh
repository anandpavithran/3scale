#!/usr/bin/env bash
set -euo pipefail

# Configuration
APP_NAME="demo-backend"
NAMESPACE="${1:-demo-api}"
BUILDER_IMAGE="registry.access.redhat.com/ubi9/python-311:latest"

echo "=========================================="
echo "Deploying ${APP_NAME} to OpenShift"
echo "Target Project: ${NAMESPACE}"
echo "=========================================="

# 1. Switch to or create project
if oc get project "${NAMESPACE}" >/dev/null 2>&1; then
    oc project "${NAMESPACE}"
else
    oc new-project "${NAMESPACE}"
fi

# 2. Create ImageStream for application
if ! oc get is "${APP_NAME}" >/dev/null 2>&1; then
    oc create imagestream "${APP_NAME}"
fi

# 3. Create or update BuildConfig using local binary/docker strategy
if ! oc get bc "${APP_NAME}" >/dev/null 2>&1; then
    echo "Creating BuildConfig for binary container build..."
    oc new-build --name="${APP_NAME}" --binary=true --strategy=docker
fi

# 4. Trigger build by streaming local directory (app.py, requirements.txt, Containerfile)
echo "Starting build and uploading local source..."
oc start-build "${APP_NAME}" --from-dir=. --follow

# 5. Create Deployment, Service, and Route if not already present
if ! oc get deployment "${APP_NAME}" >/dev/null 2>&1; then
    echo "Creating Deployment and Service..."
    oc new-app "${APP_NAME}:latest" --name="${APP_NAME}"
    
    # Configure ports and health checks
    oc set probe "deployment/${APP_NAME}" --readiness --get-url=http://:8080/healthz --initial-delay-seconds=5 --period-seconds=10
    oc set probe "deployment/${APP_NAME}" --liveness --get-url=http://:8080/healthz --initial-delay-seconds=10 --period-seconds=15
fi

# 6. Expose Service via OpenShift Route
if ! oc get route "${APP_NAME}" >/dev/null 2>&1; then
    echo "Exposing Route..."
    oc expose svc/"${APP_NAME}" --port=8080
fi

# 7. Wait for rollout
echo "Waiting for rollout to finish..."
oc rollout status "deployment/${APP_NAME}" --timeout=120s

# 8. Print endpoints
ROUTE_HOST=$(oc get route "${APP_NAME}" -o jsonpath='{.spec.host}')
echo ""
echo "=========================================="
echo "Deployment successful!"
echo "Base API URL:       http://${ROUTE_HOST}"
echo "Health Check:       http://${ROUTE_HOST}/healthz"
echo "Interactive Swagger:http://${ROUTE_HOST}/docs"
echo "ActiveDocs Spec:    http://${ROUTE_HOST}/openapi.json"
echo "=========================================="
