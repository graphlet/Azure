SHELL := /bin/bash
PROJECT ?= aca-python
ENV ?= dev
TF_DIR := infra/terraform

.PHONY: help
help:
	@echo "Targets:"
	@echo "  make tf-init        - terraform init"
	@echo "  make tf-apply       - terraform apply (dev)"
	@echo "  make tf-destroy     - terraform destroy (dev)"
	@echo "  make docker-build   - build local image"
	@echo "  make docker-run     - run container locally"

tf-init:
	cd $(TF_DIR) && terraform init -upgrade

tf-apply:
	cd $(TF_DIR) && terraform apply -auto-approve -var-file=env/$(ENV).tfvars

tf-destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve -var-file=env/$(ENV).tfvars

docker-build:
	cd app && docker build -t $(PROJECT):local .

docker-run:
	docker run --rm -p 8000:8000 $(PROJECT):local
