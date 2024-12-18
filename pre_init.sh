#!/bin/sh
export TF_VAR_terraform_version=`terraform version | grep 'Terraform v' | sed -E 's/Terraform v(.*)/\1/'`