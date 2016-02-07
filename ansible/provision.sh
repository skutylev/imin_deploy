#!/bin/bash

set -u # Variables must be explicit
set -e # If any command fails, fail the whole thing
set -o pipefail

# Make sure SSH knows to use the correct pem
ssh-add myapp.pem
ssh-add -l
# Load the AWS keys
. ./inventory/aws_keys

# Tag any existing myapp instances as being old
ansible-playbook tag-old-nodes.yaml --limit tag_Environment_myapp

# Start a new instance
ansible-playbook immutable.yaml -vv

# Now terminate any instances with tag "old"
ansible-playbook destroy-old-nodes.yaml --limit tag_oldmyapp_True