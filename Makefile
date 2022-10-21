# Globals
.PHONY: help local build accept
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Targets
LOCAL_TARGET = Local Environment Target
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
	@echo -e "local/<action> -> $$LOCAL_TARGET, action=[cluster|frontend|status|clean]"
	@echo -e "build -> $$BUILD_TARGET"
	@echo -e "accept -> $$ACCEPT_TARGET\n"

local/%:
	./scripts/local.sh $*

build:
	$(INFO) "$$BUILD_TARGET"
	./scripts/build.sh

accept:
	$(INFO) "$$ACCEPT_TARGET"
	./scripts/accept.sh
