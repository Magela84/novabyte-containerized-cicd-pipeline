## Resources Deployed
- rg-novabyte-dev          Resource Group
- acrnovabytedev001        Azure Container Registry
- id-novabyte-dev          Managed Identity with AcrPull role
- law-novabyte-dev         Log Analytics Workspace
- cae-novabyte-dev         Container Apps Environment
- ca-novabyte-dev          Container App — live at HTTPS URL

## Pipeline Status
- Stage 1 Build and Test    Ready — triggers on every push
- Stage 2 Push to ACR       Ready — triggers on merge to main
- Stage 3 Deploy Dev        Ready — automatic after push
- Stage 4 Deploy Prod       Ready — requires manual approval

## Authentication Note
Service Principal creation restricted in university tenant.
Pipeline YAML is production-ready. Infrastructure deployed
directly via Terraform and Azure CLI.
