#!/bin/bash

cd $(dirname ${0})/terraform

if [[ -z $SSH_PUBLIC_KEY ]]; then
    export SSH_PUBLIC_KEY="$(cat ${HOME}/.ssh/id_rsa.pub)"
fi

terraform apply -var "ssh-public-key=${SSH_PUBLIC_KEY}"
