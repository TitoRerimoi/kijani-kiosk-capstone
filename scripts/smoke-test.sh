#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="${NAMESPACE:-kijani-staging}"
SERVICE="${SERVICE:-kk-payments}"
PORT="${PORT:-3001}"
PATH_TO_CHECK="${PATH_TO_CHECK:-/health}"

echo "=== KijaniKiosk Staging Smoke Test ==="
echo "Namespace: $NAMESPACE"
echo "Service:   $SERVICE"
echo "Endpoint:  http://$SERVICE:$PORT$PATH_TO_CHECK"
echo

echo "[1/3] Checking deployment availability..."

kubectl wait \
  --namespace "$NAMESPACE" \
  --for=condition=available \
  deployment/"$SERVICE" \
  --timeout=120s

echo "✓ Deployment is available"

echo
echo "[2/3] Checking pod readiness..."

kubectl wait \
  --namespace "$NAMESPACE" \
  --for=condition=ready \
  pod \
  -l app="$SERVICE" \
  --timeout=120s

echo "✓ Pods are ready"

echo
echo "[3/3] Checking health endpoint..."

kubectl run smoke-test \
  --namespace "$NAMESPACE" \
  --rm \
  --stdin \
  --tty=false \
  --restart=Never \
  --image=curlimages/curl:8.10.1 \
  -- \
  curl --fail --silent --show-error \
  "http://$SERVICE:$PORT$PATH_TO_CHECK"

echo
echo "✓ Health endpoint passed"
echo
echo "=== STAGING SMOKE TEST PASSED ==="
