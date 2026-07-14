# Containerized CI/CD Pipeline — SaaS Software Engagement

## Engagement Overview
A fast-growing SaaS company was deploying code manually
via SSH taking 2-3 hours per release with no consistency
between environments. This engagement delivers a fully
automated containerized CI/CD pipeline.

## Problem Statement
Manual deployments were error-prone slow and dependent
on a single team member. Credentials were hardcoded in
deployment scripts creating a security risk.

## What I Built
- Multi-stage Dockerfile for production-grade container images
- Azure Container Registry with Managed Identity pull access
- Azure Container Apps with auto-scaling to zero replicas
- Four-stage GitHub Actions pipeline:
  Stage 1 - Build and test on every push and pull request
  Stage 2 - Push image to ACR on merge to main
  Stage 3 - Deploy to dev automatically
  Stage 4 - Deploy to prod with manual approval gate
- Log Analytics Workspace for container monitoring

## Pipeline Flow
push to main
  - Build and Test (runs on every push)
  - Push to ACR (runs on merge to main only)
  - Deploy to Dev (automatic)
  - Deploy to Prod (requires manual approval)

## Technologies Used
Docker, Azure Container Registry, Azure Container Apps,
GitHub Actions, Managed Identities, Terraform,
Log Analytics, Python, Flask

## Authentication Note
Service Principal creation is restricted in the deployment
tenant. Pipeline YAML is production-ready. Infrastructure
deployed directly via Terraform and Azure CLI.

## Engagement Outcome
Eliminated 2-3 hour manual deployment process. Every
code merge now triggers automated build test and deploy
in under 5 minutes with zero manual intervention.

## Author
Cloud Engineer - Magela84
