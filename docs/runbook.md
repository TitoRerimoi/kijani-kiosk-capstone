# KijaniKiosk Deployment Runbook

## Purpose

This runbook provides operational steps for deploying and validating the KijaniKiosk `kk-payments` workload.

## Environments

| Environment | Namespace |
|---|---|
| Staging | `kijani-staging` |
| Production | `kijani-project` |

## Pre-Deployment Checks

Confirm the Kubernetes context:

```bash
kubectl config current-context
