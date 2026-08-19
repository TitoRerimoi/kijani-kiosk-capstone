# KijaniKiosk Peer Feedback

## Review Context

This document records peer-review points considered during development of the KijaniKiosk capstone.

The feedback focuses on maintainability, deployment safety, environment separation, testing, security, and operational readiness.

## Feedback 1 — Environment Separation

**Observation:**

Staging and production should remain clearly separated so that testing does not unintentionally modify production workloads.

**Action Taken:**

The project uses separate Kubernetes namespaces:

- `kijani-staging`
- `kijani-project`

Terraform provisions the staging namespace with an explicit `environment=staging` label.

**Status:** Addressed

---

## Feedback 2 — Configuration Management

**Observation:**

Application configuration should not be hard-coded into the deployment manifest.

**Action Taken:**

The staging deployment consumes configuration through the `kk-payments-config` ConfigMap.

Environment-specific values such as `NODE_ENV`, `DB_HOST`, `DB_PORT`, and `APP_PORT` are externalized.

**Status:** Addressed

---

## Feedback 3 — Secret Handling

**Observation:**

Credentials should not be committed directly into source-controlled Kubernetes manifests.

**Action Taken:**

A Secret example file is provided with placeholder credentials only.

Repository ignore rules also cover local environment files and Kubernetes secret manifests.

**Status:** Addressed

---

## Feedback 4 — Deployment Validation

**Observation:**

A successful `kubectl apply` alone does not prove that an application is healthy.

**Action Taken:**

The project includes:

- deployment rollout validation
- pod readiness checks
- readiness probes
- liveness probes
- an automated `/health` smoke test

**Status:** Addressed

---

## Feedback 5 — Failure Testing

**Observation:**

The delivery workflow should demonstrate how it behaves when a deployment fails rather than only documenting the happy path.

**Action Taken:**

A deliberately invalid image, `v999-broken`, was deployed to staging.

The resulting `ImagePullBackOff` condition caused rollout failure and prevented the smoke test from completing successfully.

The known-good `v1.1.0` image was then restored and the staging smoke test passed.

**Status:** Addressed

---

## Feedback 6 — Production Safety

**Observation:**

Production promotion should not happen automatically immediately after a staging deployment.

**Action Taken:**

The Jenkinsfile separates staging validation from production deployment and includes an explicit manual approval gate.

The intended sequence is:

```text
Staging deployment
        |
Staging rollout
        |
Smoke test
        |
Human approval
        |
Production deployment
