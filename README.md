# Containerized CI/CD Pipeline — NovaByte Software

## Client Overview
NovaByte is a fast-growing SaaS company whose development team
was deploying code manually via SSH. Each release took 2-3 hours
and introduced inconsistencies between environments. This engagement
delivers a fully automated CI/CD pipeline that builds tests and
deploys on every code push.

## Problem Statement
The customer had no automated deployment process. Releases were
manual error-prone and dependent on a single team member who knew
the deployment steps. Credentials were hardcoded in deployment
scripts creating a security risk.

## What I Built
- Azure Container Registry for Docker image storage
- Azure Container Apps for serverless container hosting
- Managed Identity for ACR pull access — no passwords
- GitHub Actions pipeline with 4 stages:
  Stage 1 — Build and test on every push and PR
  Stage 2 — Push image to ACR on merge to main
  Stage 3 — Deploy to dev automatically
  Stage 4 — Deploy to prod with manual approval gate
- Multi-stage Dockerfile for optimized production images
- Log Analytics Workspace for container monitoring

## Authentication Note
This pipeline uses Azure Service Principal authentication.
The pipeline YAML is production-ready. Service Principal
creation is restricted in the deployment tenant (university
environment). In a customer engagement this would be
configured by a Global Administrator. Infrastructure was
deployed directly via Azure CLI and Terraform.

## Technologies Used
Docker, Azure Container Registry, Azure Container Apps,
GitHub Actions, Managed Identities, Terraform, Log Analytics

## Pipeline Flow
push to main
  → Build and Test (runs on every push)
  → Push to ACR (runs on merge to main only)
  → Deploy to Dev (automatic)
  → Deploy to Prod (requires manual approval)

## How to Deploy Infrastructure
1. Run: az login
2. Navigate to terraform/ folder
3. Run: terraform init
4. Run: terraform plan
5. Run: terraform apply -auto-approve

## Author
Cloud Engineer - Magela84
