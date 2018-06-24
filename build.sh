#!/bin/bash

cd $(dirname ${0})/terraform

if [[ -z $SSH_PUBLIC_KEY ]]; then
    export SSH_PUBLIC_KEY="$(cat ${HOME}/.ssh/id_rsa.pub)"
fi

if [[ -z $AWS_DEFAULT_REGION ]]; then
    export AWS_DEFAULT_REGION="eu-central-1"
fi

terraform init
terraform apply -var "ssh-public-key=${SSH_PUBLIC_KEY}" -auto-approve
