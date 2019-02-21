.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

_ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

ignition:
	/usr/local/bin/ct --files-dir terraform < terraform/ignition.yml > terraform/ignition.ign

ecorp-ec2:
	@cd terraform && terraform apply -var-file=$(_ROOT_DIR)/terraform.tfvars

destroy-ecorp-ec2:
	@cd terraform && TF_VAR_dd_api_key=$(DD_API_KEY) terraform destroy -var-file=$(_ROOT_DIR)/terraform.tfvars
