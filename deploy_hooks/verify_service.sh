#!/bin/bash

# Deploy hooks are run via absolute path, so taking dirname of this script will give us the path to
# our deploy_hooks directory.
. $(dirname $0)/../application_vars.sh

result=$(curl -s http://localhost:8080/health)

if [[ "$result" =~ ":thumbsup" ]]; then
    exit 0
else
    exit 1
fi
