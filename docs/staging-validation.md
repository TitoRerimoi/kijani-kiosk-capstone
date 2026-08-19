# KijaniKiosk Staging Validation

## Purpose

This document records the staging validation performed for the KijaniKiosk capstone.

The objective is to prove that:

1. A healthy `kk-payments` deployment passes automated validation.
2. A deliberately broken deployment fails validation.
3. A failed staging validation cannot proceed to production promotion.

## Successful Deployment Test

### Application Version

`kijanikiosk/kk-payments:v1.1.0`

### Environment

- Namespace: `kijani-staging`
- Replicas: 3
- Service: `kk-payments`
- Service port: `3001`
- Container port: `5000`
- Health endpoint: `/health`

### Result

The staging deployment successfully rolled out with all three replicas ready.

The smoke test verified:

- Deployment availability
- Pod readiness
- `/health` endpoint availability

Health response:

```text
{"status":"UP"}
eof
