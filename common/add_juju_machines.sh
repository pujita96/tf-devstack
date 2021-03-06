#!/bin/bash

# Adds CONTROLLER_NODES to model for manual deployment

set -o errexit
my_file="$(readlink -e "$0")"
my_dir="$(dirname $my_file)"
source "$my_dir/common.sh"

# add machines
if [[ $CLOUD == 'maas' ]] ;then
    juju add-machine -n 4
    exit
fi

if [[ -n "$CONTROLLER_NODES" || -n "$AGENT_NODES" ]]; then
    for node in $CONTROLLER_NODES $AGENT_NODES ; do
        juju add-machine ssh:ubuntu@$node
    done
fi
