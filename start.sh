#!/bin/bash

cd "$PROJECT_PATH" || exit 1

echo '####################################################'
echo '# Welcome to the Toolbox!'
echo '#'
echo '# You will find preinstalled the following tools:'
echo '# - ansible'
echo '# - packer'
echo '# - terraform'
echo '#'
echo '# If you used the docker-compose.yml to mount'
echo '# your project, you will find it in this folder.'
echo '####################################################'

/bin/bash
