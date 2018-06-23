# Terraform configuration for serving simple html file

Running `build.sh` will apply terraform state if aws credentials are configured or if specified via environment variables
Public ssh key is extracted from `${HOME}/.ssh/id_rsa.pub`, use `SSH_PUBLIC_KEY` environment variable to override it (or if there is no key in home directory)
