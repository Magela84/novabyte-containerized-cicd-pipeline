# Containerized CI/CD Pipeline — NovaByte

> **Project 3 · Magela84 Cloud Engineering Portfolio**
> Industry: Software / SaaS

## Client Overview

NovaByte is a software company that deployed containers by hand — slow,
inconsistent, and error-prone. This engagement delivers an automated
**build → test → push → deploy** pipeline with environment promotion and
a manual production gate, all on managed Azure services.

## Problem Statement

Manual container deployments gave no traceability and no safe path to
production. NovaByte needed a repeatable pipeline that builds and tests
every change, pushes versioned images to a private registry, and promotes
to production **only after approval** — with no passwords stored anywhere.

## What I Built

- **Azure Container Registry** + **Container Apps** environment (Terraform)
- **Managed Identity** with `AcrPull` — passwordless image pulls
- A **4-stage GitHub Actions pipeline** (build/test → push → deploy dev → deploy prod w/ approval)
- **Log Analytics** workspace for container observability

## Architecture

```
   push to main
        │
        ▼
 ┌───────────────┐   ┌───────────────┐   ┌──────────────┐   ┌───────────────┐
 │ 1 Build+Test  │──▶│ 2 Push to ACR │──▶│ 3 Deploy Dev │──▶│ 4 Deploy Prod │
 │ every push/PR │   │ merge to main │   │ automatic    │   │ manual approval│
 └───────────────┘   └──────┬────────┘   └──────┬───────┘   └──────┬────────┘
                            │ image               │ pull (MI)        │
                            ▼                     ▼                  ▼
                   ┌─────────────────┐   ┌────────────────────────────────┐
                   │ acrnovabytedev  │   │ cae-novabyte-dev (Container Apps)│
                   │ 001 (registry)  │   │ ca-novabyte-dev → live HTTPS URL │
                   └─────────────────┘   └────────────────────────────────┘
              Logs + metrics → law-novabyte-dev (Log Analytics)
```

## Resources Deployed

| Resource | Type | Purpose |
|---|---|---|
| `rg-novabyte-dev` | Resource Group | Container for all resources |
| `acrnovabytedev001` | Azure Container Registry | Private image store |
| `id-novabyte-dev` | Managed Identity (`AcrPull`) | Passwordless image pulls |
| `law-novabyte-dev` | Log Analytics Workspace | Container logs + metrics |
| `cae-novabyte-dev` | Container Apps Environment | Shared runtime platform |
| `ca-novabyte-dev` | Container App | The app — live at an HTTPS URL |

## Pipeline

| Stage | Trigger | Status |
|---|---|---|
| 1 · Build and Test | every push / PR | ✅ Ready |
| 2 · Push to ACR | merge to `main` | ✅ Ready |
| 3 · Deploy Dev | automatic after push | ✅ Ready |
| 4 · Deploy Prod | manual approval | ✅ Ready |

## Technologies Used

Terraform · Docker · Azure Container Registry · Container Apps · GitHub Actions · Azure CLI

## How to Deploy

```bash
git clone https://github.com/Magela84/novabyte-containerized-cicd-pipeline.git
cd novabyte-containerized-cicd-pipeline

az login
cd terraform
terraform init
terraform plan
terraform apply

# Push to main triggers the GitHub Actions pipeline.
```

> **Authentication note:** Service Principal creation was restricted in
> the training tenant, so infrastructure was deployed directly via
> Terraform and Azure CLI. The pipeline YAML is production-ready and uses
> the Managed Identity for registry access.

## Engagement Outcome

A 4-stage pipeline where every push is built, tested, and versioned in
ACR, deployed automatically to dev, and promoted to production **only
behind a manual approval gate** — with a live HTTPS endpoint and full
container observability in Log Analytics.

## Author

**Magela84** — Cloud Engineer
[github.com/Magela84](https://github.com/Magela84)
