STACK ?= aws-ecs
DIR := environments/$(STACK)

.PHONY: fmt init validate offline-plan plan

fmt:
	terraform fmt -recursive -check

init:
	terraform -chdir=$(DIR) init -backend=false

validate: init
	terraform -chdir=$(DIR) validate

offline-plan: validate
	terraform -chdir=$(DIR) test -verbose -no-color

plan:
	terraform -chdir=$(DIR) init
	terraform -chdir=$(DIR) plan -out=tfplan
