# Azure Container Apps – Python + Terraform Starter (Reference Implementation)

This repo is a production‑ready, **reference baseline** for running a Python (FastAPI) service on **Azure Container Apps (ACA)** with **Terraform** for infrastructure.
It keeps **business logic** and **infrastructure code** cleanly separated and ships with a **GitHub Actions** workflow for build + deploy.

## Repo layout

```
.
├── app/                      # Your Python service (business logic)
│   ├── src/
│   │   └── main.py
│   ├── tests/
│   │   └── test_smoke.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── .dockerignore
│   └── README.md
├── infra/                    # Infrastructure-as-code (Terraform)
│   └── terraform/
│       ├── env/             # Per-environment variables
│       │   └── dev.tfvars
│       ├── modules/         # Reusable TF modules
│       │   ├── container_app/
│       │   │   ├── main.tf
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   ├── log_analytics/
│       │   │   ├── main.tf
│       │   │   └── outputs.tf
│       │   └── acr/
│       │       ├── main.tf
│       │       └── outputs.tf
│       ├── main.tf          # Root stack: RG + modules wired together
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── locals.tf
│       └── backend.tf.example
├── .github/workflows/deploy.yml
├── Makefile
└── .gitignore
```

> **Note on ACR auth**: For “works out of the box” simplicity in CI, this starter enables the **ACR admin user** and uses those credentials for both image push and at‑runtime image pull. In production, swap this for **managed identity** + appropriate registry permissions (`AcrPull`/`AcrPush`) and disable the admin account.

## Quick start

1) **Fork or download** this repo.  
2) Create **GitHub secrets** (Settings → Secrets and variables → Actions):
   - `AZURE_CLIENT_ID` – service principal (or workload identity) client ID for OIDC
   - `AZURE_TENANT_ID` – tenant ID
   - `AZURE_SUBSCRIPTION_ID` – subscription ID
3) (Optional) Edit `infra/terraform/env/dev.tfvars` (names/region). Default region is `UK South`.
4) Push to `main`. The workflow will:
   - Provision resource group, Log Analytics, ACR, and ACA environment
   - Build & push the image
   - Deploy/Update the Container App
5) After deploy, the job prints the **Container App URL**.

## Local development

```bash
# from ./app
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
# open http://localhost:8000
```

## Terraform state

By default this uses **local state** so you can run without extra setup. For a shared/prod setup switch to **remote state** in Azure Storage using `infra/terraform/backend.tf.example` as a template.

## CI/CD

The provided workflow uses **GitHub OIDC → azure/login** for ARM auth, builds the Docker image, pushes to ACR, then runs Terraform to apply the latest tag to ACA.


## Production hardening checklist

- [ ] Switch ACR auth to **managed identity** + `AcrPull` for the app, `AcrPush` for CI, **disable admin user**.
- [ ] Use **private networking** (VNET integrated ACA Env) and IP restrictions.
- [ ] Configure **Key Vault** for secrets.
- [ ] Enable **blue/green** via multi‑revision traffic split.
- [ ] Use **workload profiles** if you need dedicated compute.
- [ ] Replace local TF state with **Azure Storage backend**.
- [ ] Add **monitoring/alerts** via Azure Monitor / Log Analytics queries.
- [ ] Add **slim containers**, SBOM, vulnerability scanning.
- [ ] Pin exact provider versions and use **dependency lock file**.

---

### Why no `location` in `azurerm_container_app`?
Location is inferred from the **Container App Environment**—do **not** set it on the app resource. (The module provided here follows that rule.)

