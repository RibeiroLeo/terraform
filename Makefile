STACK ?= aws-ecs
DIR := environments/$(STACK)

.PHONY: fmt init validate plan

fmt:
	terraform fmt -recursive -check

init:
	terraform -chdir=$(DIR) init -backend=false

validate: init
	terraform -chdir=$(DIR) validate

plan:
	terraform -chdir=$(DIR) init
	terraform -chdir=$(DIR) plan -out=tfplan
