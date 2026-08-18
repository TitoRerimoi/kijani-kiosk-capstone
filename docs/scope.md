# KijaniKiosk Capstone Scope Document

## Problem Statement

The current KijaniKiosk Kubernetes deployment provides production-readiness controls including rolling updates, health probes, resource limits, externalized configuration, services, and Ingress routing, but it operates without an isolated staging environment or a controlled promotion workflow. Changes therefore lack an automated staging validation step before production deployment. The capstone will extend the existing Kubernetes platform into a reproducible staging-to-production delivery workflow where changes are automatically deployed to staging, validated through smoke tests, and promoted to production only after explicit approval.

## Track

**Track A — Infrastructure-First**

## What I Will Build

- **Staging environment:** Provision a dedicated `kijani-staging` Kubernetes namespace and configure it separately from the existing `kijani-project` production environment using Infrastructure as Code.
- **Environment-specific Kubernetes configuration:** Deploy `kk-payments` to staging using the same application deployment pattern while providing staging-specific configuration, including an environment-specific database host.
- **CI/CD promotion pipeline:** Extend Jenkins so that merges to `main` deploy to staging automatically, execute a smoke test, and present a manual production approval gate only when staging validation succeeds.
- **Failure and monitoring controls:** Add deployment validation and a committed monitoring signal for `kk-payments` so unhealthy or failed staging deployments cannot proceed to production.
- **AI governance:** Document AI-assisted engineering work using the Week 10 eight-field governance format, including human review, identified errors, and changes made before applying AI-generated output.

## What Is Out of Scope

- **Multi-region infrastructure:** The capstone focuses on environment separation and controlled deployment rather than geographic redundancy.
- **Full enterprise observability:** A single meaningful monitoring signal is sufficient to demonstrate the observability principle; a complete Prometheus/Grafana production platform is not required.
- **Real customer production traffic:** The existing production namespace is used to demonstrate controlled promotion, but the capstone does not claim that the environment is ready for real customer workloads.
- **Application feature development:** The capstone extends the delivery and infrastructure capabilities of KijaniKiosk rather than adding new business functionality.
- **Automatic production deployment:** Production promotion will retain an explicit human approval step to demonstrate controlled change management.

## Success Criteria

1. A merge to `main` triggers the Jenkins pipeline and automatically deploys `kk-payments` to the isolated `kijani-staging` environment, followed by a successful smoke test.
2. The production deployment stage remains blocked until an explicit approval is provided, and only a version that has successfully passed staging validation can be promoted.
3. A deliberately introduced staging deployment failure is detected by the validation process and prevents promotion to production.

## Architecture Diagram

See `docs/architecture.png` for the complete architecture and labelled deployment, runtime, infrastructure, validation, approval, and monitoring flows.
