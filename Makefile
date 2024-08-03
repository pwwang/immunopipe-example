SHELL := /bin/bash
ALL_CONFIGS := $(subst .config.toml,,$(wildcard *.config.toml))
msg ?= init
runner ?= apptainer

help:
	@echo "Usage: make [target] [runner=apptainer|local] [msg=commit message]"
	@echo "Targets:"
	@echo "  help: Show this help message"
	@echo "  all: Run all configurations (without .config.toml)"
	@echo "      runner=apptainer|local: Run with apptainer or locally"
	@echo "  data: Prepare data"
	@echo "  list-configs: List all configurations"
	@echo "  <config>: Run a specific configuration (without .config.toml)"
	@echo "      runner=apptainer|local: Run with apptainer or locally"
	@echo "  commit: Commit changes without history"
	@echo "      msg=commit message: Commit message"
	@echo "  push: Commit and push changes to remote without history"
	@echo "      msg=commit message: Commit message"
	@echo "  submit: Alias for push"
	@echo "      msg=commit message: Commit message"

all: $(ALL_CONFIGS)

data:
	bash prepare-data.sh

list-configs:
	@echo $(ALL_CONFIGS) | tr ' ' '\n'

%: %.config.toml
	@if [ "$(runner)" = "local" ]; then \
		echo immunopipe @$< \
			--name $(shell basename $< .config.toml)Local \
			--outdir $(shell grep -oP 'outdir = "\K[^"]+' $<)-local; \
		immunopipe @$< \
			--name $(shell basename $< .config.toml)Local \
			--outdir $(shell grep -oP 'outdir = "\K[^"]+' $<)-local; \
	else \
		echo apptainer run --pwd /workdir -B .:/workdir,/tmp -c -e --unsquash --writable-tmpfs \
			docker://justold/immunopipe:dev-full \
			@$<; \
		apptainer run --pwd /workdir -B .:/workdir,/tmp -c -e --unsquash --writable-tmpfs \
			docker://justold/immunopipe:dev-full \
			@$<; \
	fi

commit:
	@rm -rf .git/; \
	git init; \
	git add .; \
	git commit -m "$(msg)"; \
	git remote add origin https://github.com/pwwang/immunopipe-example.git;

push:
	make commit msg="$(msg)"; \
	git push -u --force origin master

submit: push

.PHONY: all data commit push submit list-configs
