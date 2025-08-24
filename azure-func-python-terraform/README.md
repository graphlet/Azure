# Azure Functions (Python) + Terraform – Reference Template

A production‑ready, **opinionated starter** for running Python on Azure Functions with infrastructure defined in Terraform. It keeps **business logic** and **infrastructure code** cleanly separated while still living in the same repo.

## Highlights

- Python Azure Functions v4 (Python 3.11) using the **decorator/blueprint** model.
- Clear layering: **handlers (triggers)** → **services (business logic)** → **schemas (validation)** → **config**.
- Terraform IaC with **modules** for resource group, storage, Function App, App Insights, Key Vault.
- **System-assigned managed identity**, Key Vault secret references, Application Insights logging.
- **GitHub Actions** for CI (tests, lint) and CD (Terraform plan/apply, Functions deploy).
- Local dev via **Azure Functions Core Tools** and **Azurite**; reproducible with `Makefile` targets.
- Security-minded defaults: no secrets committed, Key Vault + app settings, `.funcignore`, `.gitignore`.
- Unit tests with `pytest` for both services and HTTP handler.

---

## Structure

```
.
├── README.md
├── LICENSE
├── Makefile
├── pyproject.toml
├── requirements.in                 # Editable deps (compiled to requirements.txt)
├── requirements.txt                # Locked deps for Azure build
├── host.json
├── .funcignore
├── local.settings.example.json
├── src/
│   └── app/
│       ├── __init__.py
│       ├── function_app.py        # Registers blueprints (triggers) with the app
│       ├── config.py              # Pydantic settings
│       ├── logging_conf.py        # Structured logging setup
│       ├── handlers/
│       │   ├── __init__.py
│       │   └── hello.py           # HTTP trigger (POST /api/hello)
│       ├── schemas/
│       │   ├── __init__.py
│       │   └── hello.py           # Request model
│       └── services/
│           ├── __init__.py
│           └── greeting_service.py
│
├── tests/
│   ├── __init__.py
│   └── test_hello.py
│
├── scripts/
│   ├── create_venv.sh
│   ├── run_locally.sh
│   └── init_terraform_backend.sh
│
├── infra/                          # Terraform
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── versions.tf
│   ├── backend.tf                  # (edit for remote state when ready)
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── resource_group/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── storage_account/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── log_analytics/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── app_insights/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       ├── key_vault/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── function_app/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
└── .github/workflows/
    ├── ci.yml
    ├── terraform-plan.yml
    ├── terraform-apply.yml
    └── deploy-function.yml
```

---

## Quickstart

### 1) Prereqs
- Python 3.11, `pip`
- Azure Functions Core Tools v4
- Docker (optional)
- Azure CLI (`az`)
- Terraform >= 1.7
- Azurite (local storage emulator) if running locally

### 2) Local dev

```bash
make venv
make install
make start   # starts func host locally (uses local.settings.example.json if you copy it)
```

Hit the sample endpoint:

```bash
curl -X POST http://localhost:7071/api/hello -H "Content-Type: application/json" -d '{"name":"Kamlesh"}'
# => {"message":"Hello, Kamlesh!"}
```

### 3) Terraform (create infra)

Edit `infra/terraform.tfvars.example` and copy to `infra/terraform.tfvars`.

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 4) Deploy Function Code

Using GitHub Actions (preferred) – push to `main` and let `deploy-function.yml` run, **or** deploy manually:

```bash
# Build a package and push via Azure CLI (requires publish profile or OIDC)
func azure functionapp publish <your_function_app_name> --python
```

---

## Secrets & Config

- Local: copy `local.settings.example.json` to `local.settings.json`. Do **not** commit it.
- Cloud: use Function App **App Settings** + **Key Vault** references.
- Identity: the Function App has a **system-assigned managed identity**; grant it access to Key Vault.


## CI/CD (GitHub)

- `ci.yml`: lint + tests
- `terraform-plan.yml`: plan on PRs using OIDC to Azure
- `terraform-apply.yml`: manual apply via environment approval
- `deploy-function.yml`: build & deploy the code to the Function App on pushes to `main`


## Notes

- Python worker version is resolved by Azure; target **Python 3.11**.
- This template uses the **decorator model** and **Blueprints** to keep triggers thin.
- All business logic lives under `src/app/services/` or domain layers.
