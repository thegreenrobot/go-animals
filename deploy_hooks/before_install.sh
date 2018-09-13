#!/bin/bash

# Check for salt, and attempt to install if not

pgrep animals.tux &> /dev/null
if [ $? != 0 ]; then
    supervisorctl start animals
fi
