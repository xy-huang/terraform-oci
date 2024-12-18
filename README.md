# terraform-oci
OCI always-free tier offers VM.Standard.A1.Flex up to 4 OCPUs, 24Gb memories and 200Gb storage for each account for free use. This repository contains Terraform scripts for deploying Oracle Cloud Infrastructure (OCI) these always-free resources, including:
 - network (VCN, subnet, internet gateway, route table, VNICs, etc.)
 - compute (instance of VM.Standard.A1.Flex with 4 OCPUs, 24Gb memories and 200Gb storage)

By default the terraform state files are stored in OCI archive storage created in your account (always-free tier offers up to 20GB). 

You can change the backend configuration to use other storage options like object storage bucket or file system. 

All above resources are covered by the OCI always-free tier unless you already have more resources in your account. 

## Prerequisites
### Install terraform
To get started with this repository, you will need to have Terraform installed on your machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html).

set terraform_version as environment variable (to be used in resource tag `Operation-Tags.TerraformVersion`)
```shell
export TF_VAR_terraform_version=`terraform version | grep 'Terraform v' | sed -E 's/Terraform v(.*)/\1/'`
```

### Upgrade OCI account to Pay As You GO (PAYG)
If your OCI account type is always-free, You are likely to encounter the "Out of Host capacity" error when you are trying to create the instance under always-free tier. Upgrade your OCI account to Pay As You Go (PAYG). You can do this and confirm in OCI console: `Nevigation menu -> Billing & Cost Management -> Upgrade and Manage Payment`.

***Note: Be careful to ensure that your account does not exceed the always-free capacity when you create or modify OCI resources in your account. It's better to review your billing report monthly(daily) to avoid unexpected costs.***

### Create OCI Object Storage & Archive Storage Bucket
By default the terraform state file defined in `backend.tf` will be stored in OCI Object Storage & Archive Storage Bucket, and terraform will use this bucket as AWS S3 compatible backend.

Navigate to `Nevigation menu -> Object Storage -> Buckets`, click on `Create Bucket`, and then fill in the required information to create the bucket `bucket_name`. 

After that, click the bucket and get the `Namespace` value.

### Configure OCI credentials

Assuming you are using account named `{domain_name}\{username}`.

To generate `secret key`, navigate to `Nevigation menu -> Identity & Security -> Domains`, in `{domain_name} -> Users`, click on `{username}` and then `Customer secret keys`, and then click on the `Generate secret key` to generate a new `secret key`. 

***The `Secret Key` value won't be shown again, so you should save the secret key to an appropriate location.***

After that, you will see a new record in `Customer secret keys` section, get the `Access Key`.

To generate `API key`, navigate to `Nevigation menu -> Identity & Security -> Domains`, in `{domain_name} -> Users`, click on `{username}` and then `API keys`, and then click on the `Add API key` to generate a new `API key pair` (of course you can use existing API key pair if you have one). 

***The `private key` value won't be shown again, so you should download the key files to an appropriate location, for example: `~/.oci/keys/<username>@<domain>.pem`.***

After that, you will see a new record in `API keys` section, get the `Fingerprint`. 

Make sure your credential configuration files have the correct permissions (600) and the correct owner (your user account).
```shell
chmod -R 600 ~/.oci/*
```

Now, let's set environment variables to your shell for backend settings:

```shell
export AWS_DEFAULT_REGION=<Region>
export AWS_ACCESS_KEY_ID=<Access Key>
export AWS_SECRET_ACCESS_KEY=<Secret Key>
export AWS_ENDPOINT_URL_S3=https://<Namespace>.compat.objectstorage.<Region>.oraclecloud.com
export AWS_DEFAULT_OUTPUT=json
```

And then for provider credentials:

```shell
TF_VAR_tenancy_ocid=<profile_tenancy_ocid>
TF_VAR_user_ocid=<domain_user_ocid>
TF_VAR_region=<Region>
TF_VAR_fingerprint=<Fingerprint>
TF_VAR_private_key_path=<path_to_private_key>
```

### Create required policies

Assuming you are using account named `{username}` which belongs to domain `{domain_name}` and in group `{group_name}`.

To create the required policies, navigate to `Nevigation menu -> Identity & Security -> Policies`, and then click on `Create Policy`.

```
Allow group '<domain_name>'/'<group_name>' to manage buckets in tenancy where all {target.name!='${bucket_name}'}
Allow group '${domain_name}'/'${group_name}' to read buckets in tenancy where all {target.name='${bucket_name}'}
Allow group '${domain_name}'/'${group_name}' to manage objects in tenancy where all {target.bucket.name='${bucket_name}'}
Allow group '${domain_name}'/'${group_name}' to manage auto-scaling-configurations in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-capacity-reports in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-capacity-reservations in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-clusters in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-global-image-capability-schema in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-image-capability-schema in tenancy
Allow group '${domain_name}'/'${group_name}' to manage compute-management-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage dedicated-vm-hosts in tenancy
Allow group '${domain_name}'/'${group_name}' to manage instance-agent-command-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage instance-agent-commands in tenancy
Allow group '${domain_name}'/'${group_name}' to manage instance-agent-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage instance-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage virtual-network-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage volume-family in tenancy
Allow group '${domain_name}'/'${group_name}' to manage work-requests in tenancy
Allow group '${domain_name}'/'${group_name}' to manage tag-namespaces in tenancy
allow any-user to inspect tag-namespaces in tenancy
```

### Generate ssh key pair file
You can use the following command to generate a new SSH key pair:

```shell
cd ~/.ssh
ssh-keygen -t ed25519 -C "<account_email>"
chmod 600 id_ed25519
```

This will generate a new SSH key pair with the name `id_ed25519` and `id_ed25519.pub` in the ~/.ssh. You can then use this key pair to create and connect to your instances.

## Quick Start
Clone this repository to your local machine using the following command:

```
git clone https://github.com/xy-huang/terraform-oci-core.git
```

Navigate to the cloned repository directory:

```
cd terraform-oci-core
```

create a file called `s3.tfbackend`

```shell
cat > s3.tfbackend << EOF
bucket = "<bucket_name>"
key = "<path_to_terraform_state_file, for_example: default/terraform.tfstate>"
skip_region_validation = true
skip_credentials_validation = true
skip_requesting_account_id = true
use_path_style = true
skip_metadata_api_check = true
skip_s3_checksum = true
EOF
```

create a file called `.tfvars`

```shell
cat > .tfvars << EOF
compartment_id = "<compartment_ocid>"
ssh_authorized_keys = "<the content of ~/.ssh/id_ed25519.pub>"
user_data = <<-EOT
#!/bin/sh
# you can write user script here to initialize your instance
# for example, to attach to your ubuntu pro:
# pro attach <Token>
EOT
```

Initialize the Terraform configuration

```shell
terraform init -backend-config=.s3.tfbackend -var-file=.tfvars
```

Plan the changes

```shell
terraform plan -var-file=.tfvars
```

Create the resources

```shell
terraform apply -var-file=.tfvars
```

## Usage

You can use the Terraform commands to manage the OCI resources. For example, to initialize the Terraform configuration, run:

```shell
terraform init -backend-config=.s3.tfbackend -var-file=.tfvars
```

To reinitialize the Terraform configuration, run:

```shell
terraform init -backend-config=.s3.tfbackend -var-file=.tfvars -reconfigure
```

To upgrade providers and plugins, run:

```shell
terraform init -backend-config=.s3.tfbackend -var-file=.tfvars -upgrade
```

To plan the changes, run:

```shell
terraform plan -var-file=.tfvars
```

To create the resources, run:

```shell
terraform apply -var-file=.tfvars
```

To destroy the resources, run:

```shell
terraform destroy -var-file=.tfvars
```

For more information on using Terraform with OCI, please refer to the [Terraform official documentation](https://www.terraform.io/docs/index.html) and the [OCI provider official documentation](https://www.terraform.io/docs/providers/oci/index.html).