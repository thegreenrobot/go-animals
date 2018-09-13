SHELL := /bin/bash
MAKEFILE_RULES := $(shell cat Makefile | grep "^[A-Za-z]" | awk '{print $$1}' | sed "s/://g" | sort -u)

.SILENT: help
.PHONY: $(MAKEFILE_RULES)

default: help

format:  ## Format the go
	@echo "!!! go formart !!! "
	go fmt src/*.go

build:  ## Build the go for osx
	@echo "!!! go build osx !!! "
	go build -o animals.osx src/*

build-linux:  ## Build the go for linux
	@echo "!!! go build linux !!! "
	GOOS=linux GOARCH=amd64 go build -o animals.tux src/*

run:  ## Run the go
	@echo "!!! run all the things !!! "
	./main

version:  ## Generate version file
	@echo "!!! creating version file !!! "
	git rev-parse HEAD > version.txt

artifact:  ## Create artifact
	@echo "!!! creating release artifact !!! "
	tar zcvf `git rev-parse HEAD`.tar.gz version.txt animals.tux
	md5 -q `git rev-parse HEAD`.tar.gz > `git rev-parse HEAD`.tar.gz.MD5

appspec: ## Create appspec artifact
	@echo "!!! creating codedeploy appspec artifact !!! "
	zip -r `git rev-parse HEAD`.zip appspec.yml deploy_hooks

push:  ## Push artifact - arg1=YOURBUCKET
	@echo "!!! push artifact somewhere !!! "
	aws s3 cp `git rev-parse HEAD`.tar.gz s3://$(arg1)
	aws s3 cp `git rev-parse HEAD`.tar.gz.MD5 s3://$(arg1)
	aws s3 cp `git rev-parse HEAD`.zip s3://$(arg1)

clean:  ## Clean up - delete local artifacts
	@echo "!!! deleting local artifacts !!! "
	rm  `git rev-parse HEAD`.tar.gz*
	rm  `git rev-parse HEAD`.zip

release: ## Create release - artifact|push
	@echo "!!! release all the things !!! "
release: version build build-linux artifact appspec push

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
