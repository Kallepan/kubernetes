# Variables
TERRAFORM_SOURCE_DIRECTORY := src
ENVIRONMENT := default

export TF_VAR_registry_token := $(shell sops -d environments/${ENVIRONMENT}/secrets.yaml | yq .global.registry.password)
export TF_VAR_registry_url := $(shell sops -d environments/${ENVIRONMENT}/secrets.yaml | yq .global.registry.url)
export TF_VAR_registry_username := $(shell sops -d environments/${ENVIRONMENT}/secrets.yaml | yq .global.registry.username)

# Default target
.DEFAULT_GOAL := bootstrap

# Phony targets
.PHONY: \
	check-tools \
	start-minikube \
	terraform-init \
	terraform-apply \
	bootstrap \
	clean \
	sops

# Check if required tools are installed
check-tools:
	@command -v minikube >/dev/null 2>&1 || { echo >&2 "Minikube is not installed. Please install it first."; exit 1; }
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "Terraform is not installed. Please install it first."; exit 1; }

# Start Minikube if not already running
start-minikube: check-tools
	@if ! minikube status >/dev/null 2>&1; then \
		echo "Starting Minikube..."; \
		minikube start --driver=docker; \
	else \
		echo "Minikube is already running."; \
	fi

# Initialize Terraform
terraform-init: check-tools
	@echo "Initializing Terraform..."
	terraform -chdir=$(TERRAFORM_SOURCE_DIRECTORY) init

# Apply Terraform configuration
terraform-apply: check-tools
	@echo "Applying Terraform configuration..."
	terraform -chdir=$(TERRAFORM_SOURCE_DIRECTORY) apply -auto-approve

# Bootstrap the environment
bootstrap: start-minikube terraform-init terraform-apply
	@echo "Environment bootstrapped successfully!"

# Clean up resources
clean: check-tools
	@echo "Cleaning up Terraform state..."
	rm -f $(TERRAFORM_SOURCE_DIRECTORY)/*.tfstate*
	@echo "Stopping Minikube..."
	minikube delete --all
	@echo "Resources cleaned up successfully!"

# Decrypt SOPS secrets for inspection
sops:
	@echo "Unlocking SOPS secrets..."
	sops -d environments/default/secrets.yaml
	@echo "SOPS secrets unlocked successfully!"
