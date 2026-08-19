# KijaniKiosk AI Governance Log

## Purpose

This document records how AI assistance was used during development of the KijaniKiosk capstone and how generated suggestions were reviewed, tested, corrected, and validated by the project owner.

## 1. Task / Problem

AI assistance was used to help structure the KijaniKiosk staging-to-production delivery workflow, including:

- Terraform infrastructure
- Ansible configuration
- Kubernetes manifests
- Smoke testing
- Monitoring
- Jenkins pipeline design
- Deployment documentation
- Failure and recovery testing

## 2. AI Contribution

AI was used primarily for:

- proposing implementation structures
- drafting configuration examples
- suggesting validation commands
- identifying likely configuration issues
- improving documentation structure
- helping interpret command output and deployment failures

AI-generated suggestions were treated as development assistance rather than authoritative implementation.

## 3. Human Review

All generated configuration and commands were reviewed before execution.

The project owner:

- executed the commands locally
- inspected Kubernetes resources
- verified Terraform state
- verified Ansible execution
- reviewed deployment status
- inspected pod behaviour
- tested the application health endpoint
- performed a deliberate broken-image deployment
- restored the known-good version
- verified recovery

## 4. Validation

The implementation was validated using real execution results.

Examples include:

- Terraform successfully creating `kijani-staging`
- Ansible successfully configuring `kk-payments-config`
- three staging replicas becoming ready
- `/health` returning `{"status":"UP"}`
- monitoring reporting `3/3` available replicas
- a deliberately broken image producing `ImagePullBackOff`
- the failed rollout exceeding its progress deadline
- restoration to `v1.1.0`
- successful post-recovery smoke testing

## 5. AI-Assisted Errors and Corrections

AI assistance was not assumed to be error-free.

During development, several issues were identified and corrected through human execution and verification, including:

- incomplete documentation files
- incorrect or incomplete shell heredoc content
- attempts to execute documentation text as shell commands
- an unavailable Python virtual-environment path
- missing Python Kubernetes dependencies
- Ansible initially using the system Python interpreter
- a malformed Kubernetes deployment manifest
- a deliberately broken container image used for failure testing

These issues were resolved through direct inspection, command output, configuration changes, and repeated validation.

## 6. Security and Secret Handling

AI-generated examples were reviewed to avoid committing real credentials.

The repository uses:

- `.gitignore` rules for environment files
- Terraform state exclusion
- `.tfvars` exclusion
- Kubernetes secret manifest exclusions
- an example Kubernetes Secret containing placeholder credentials

The repository does not intentionally store real production credentials.

## 7. Human Decision Authority

The project owner retained final responsibility for:

- architecture decisions
- environment separation
- infrastructure changes
- Kubernetes deployment decisions
- security decisions
- test execution
- failure injection
- recovery actions
- production promotion design

AI recommendations were accepted only after they were technically reviewed and tested.

## 8. Final Assessment

AI assistance accelerated planning, troubleshooting, implementation, and documentation.

However, the final implementation was validated through direct execution against the Kubernetes environment and Git repository.

The successful staging deployment, deliberate failure, recovery, smoke testing, monitoring check, and production approval design provide evidence that the final result was not accepted solely on the basis of AI-generated output.
