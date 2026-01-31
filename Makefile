SHELL := /bin/bash
.PHONY: lint validate bootstrap

lint:
	@echo "Linting manifests..."

validate:
	@echo "Validating manifests with kubectl (dry-run)"

bootstrap:
	@echo "Bootstrap cluster (see scripts/bootstrap-cluster.sh)"
