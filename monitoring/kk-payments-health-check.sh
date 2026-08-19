#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="${NAMESPACE:-kijani-staging}"
DEPLOYMENT="${DEPLOYMENT:-kk-payments}"

DESIRED=$(kubectl get deployment "$DEPLOYMENT" \
  -n "$NAMESPACE" \
  -o jsonpath='{.spec.replicas}')

AVAILABLE=$(kubectl get deployment "$DEPLOYMENT" \
  -n "$NAMESPACE" \
  -o jsonpath='{.status.availableReplicas}')

AVAILABLE="${AVAILABLE:-0}"

if [ "$AVAILABLE" -ne "$DESIRED" ]; then
    echo "CRITICAL: $DEPLOYMENT has $AVAILABLE/$DESIRED available replicas."
    exit 1
fi

echo "OK: $DEPLOYMENT has $AVAILABLE/$DESIRED available replicas."
