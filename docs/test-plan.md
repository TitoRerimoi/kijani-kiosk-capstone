# KijaniKiosk Capstone Test Plan

## Purpose

This test plan validates the KijaniKiosk staging-to-production delivery workflow.

The tests verify infrastructure provisioning, environment configuration, application health, failure detection, recovery, and controlled production promotion.

## Test Environment

| Component | Value |
|---|---|
| Kubernetes | Minikube |
| Kubernetes version | v1.35.1 |
| Staging namespace | `kijani-staging` |
| Production namespace | `kijani-project` |
| Application | `kk-payments` |
| Staging replicas | 3 |
| Application image | `kijanikiosk/kk-payments:v1.1.0` |

## Test Cases

### TC-01 — Terraform Staging Namespace

**Objective:** Confirm Terraform can provision the isolated staging namespace.

**Expected:** Terraform validates successfully and creates `kijani-staging` with the expected environment labels.

**Observed Result:** PASS

The namespace was provisioned with:

- `environment=staging`
- `project=kijani-kiosk`
- `managed_by=terraform`

### TC-02 — Ansible Staging Configuration

**Objective:** Confirm Ansible configures the staging application environment.

**Observed Result:** PASS

The `kk-payments-config` ConfigMap contains staging-specific configuration including:

- `NODE_ENV=staging`
- `DB_HOST=postgres-staging.kijani.internal`
- `DB_PORT=5432`
- `APP_PORT=5000`
- `LOG_LEVEL=info`
- `MAX_CONNECTIONS=10`

### TC-03 — Staging Deployment

**Objective:** Confirm `kk-payments` deploys successfully to the isolated staging namespace.

**Observed Result:** PASS

The deployment successfully rolled out with three ready replicas.

### TC-04 — Staging Smoke Test

**Objective:** Verify application availability and the `/health` endpoint.

**Observed Result:** PASS

The smoke test confirmed deployment availability, pod readiness, and a healthy response:

`{"status":"UP"}`


### TC-05 — Deliberate Staging Failure

**Objective:** Confirm a broken image is detected and cannot pass staging validation.

The staging image was deliberately changed from:

`kijanikiosk/kk-payments:v1.1.0`

to:

`kijanikiosk/kk-payments:v999-broken`

**Expected:** New pods fail to start and staging validation fails.

**Observed Result:** PASS

The broken deployment produced `ImagePullBackOff` and exceeded its rollout progress deadline. The smoke test failed during pod readiness.

### TC-06 — Staging Recovery

**Objective:** Confirm recovery after the failed deployment.

The known-good image was restored:

`kijanikiosk/kk-payments:v1.1.0`

**Observed Result:** PASS

The deployment successfully rolled out with three ready replicas and the smoke test returned:

`{"status":"UP"}`

### TC-07 — Monitoring Signal

**Objective:** Confirm the monitoring script detects replica availability.

**Command:**

`./monitoring/kk-payments-health-check.sh`

**Observed Result:** PASS

The script reported:

`OK: kk-payments has 3/3 available replicas.`

### TC-08 — Production Approval Gate

**Objective:** Confirm production promotion requires explicit approval.

The Jenkins pipeline performs staging deployment, rollout validation and smoke testing before reaching the production approval stage.

**Observed Result:** IMPLEMENTED

The Jenkinsfile contains a manual approval gate before production deployment.

## Acceptance Criteria

| Criterion | Result |
|---|---|
| Staging namespace provisioned with IaC | PASS |
| Staging configuration externalized | PASS |
| Application deployed to staging | PASS |
| Health/readiness validation works | PASS |
| Smoke test passes on healthy deployment | PASS |
| Broken deployment detected | PASS |
| Failed staging validation blocks promotion | PASS |
| Failed deployment can be recovered | PASS |
| Monitoring signal committed | PASS |
| Production requires explicit approval | IMPLEMENTED |

## Evidence

- `docs/staging-validation.md`
- `docs/runbook.md`
- `scripts/smoke-test.sh`
- `monitoring/kk-payments-health-check.sh`
- `Jenkinsfile`
- `terraform/`
- `ansible/`
- `k8s/`
