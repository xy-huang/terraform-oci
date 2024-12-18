locals {
  pre_defined_tags = {
    "Operation-Tags.CreatedBy"        = "Terraform"
    "Operation-Tags.TerraformVersion" = var.terraform_version
    "Resource-Tags.Region"            = var.region
  }
}
