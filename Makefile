# Globals
.PHONY: help
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Targets
BUILD_TARGET = Build Target
ACCEPT_TARGET = Accept Target - Deploy

# Colours for Help Message and INFO formatting
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'
export 

help:
	$(INFO) "Run: make <target>"
	$(INFO) "List of Supported Targets:"
	@echo -e "build -> $$BUILD_TARGET"
	@echo -e "accept -> $$ACCEPT_TARGET\n"

build:
	$(INFO) "$$BUILD_TARGET"
	./scripts/build.sh

accept:
	$(INFO) "$$ACCEPT_TARGET"
	./scripts/accept.sh
