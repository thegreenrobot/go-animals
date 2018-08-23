SHELL := /bin/bash
MAKEFILE_RULES := $(shell cat Makefile | grep "^[A-Za-z]" | awk '{print $$1}' | sed "s/://g" | sort -u)

.SILENT: help
.PHONY: $(MAKEFILE_RULES)

default: help

format:  ## Format the go
	@echo "!!! go formart !!! "
	go fmt src/*.go

build:  ## Build the go
	@echo "!!! go build !!! "
	go build src/*

run:  ## Run the go
	@echo "!!! run all the things !!! "
	./main

version:  ## Generate version file
	@echo "!!! creating version file !!! "
	git rev-parse HEAD > version.txt

artifact:  ## Create artifact
	@echo "!!! creating release artifact !!! "
	tar zcvf `git rev-parse HEAD`.tar.gz version.txt main

push:  ## Push artifact - arg1=YOURBUCKET
	@echo "!!! push artifact somewhere !!! "
	aws s3 cp `git rev-parse HEAD`.tar.gz s3://$(arg1)

release: ## Create release - artifact|push
	@echo "!!! release all the things !!! "
release: version artifact push

help:  ## This help dialog.
	echo "                 _         __ _ _        "
	echo "     /\/\   __ _| | _____ / _(_) | ___   "
	echo "    /    \ / _' | |/ / _ \ |_| | |/ _ \  "
	echo "   / /\/\ \ (_| |   <  __/  _| | |  __/  "
	echo "   \/    \/\__,_|_|\_\___|_| |_|_|\___|  "
	echo "    You can run the following commands from this$(MAKEFILE_LIST):\n"
	IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sort`) ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-30s %s\n" $$help_command $$help_info ; \
	done
