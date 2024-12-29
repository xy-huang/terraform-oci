locals {
  pre_defined_tags = {
    "Operation-Tags.CreatedBy"        = "Terraform"
    "Operation-Tags.TerraformVersion" = var.terraform_version
    "Resource-Tags.Region"            = var.region
  }
  security_rule_protocles = {
    TCP    = "6"
    UDP    = "17"
    ICMP   = "1"
    ICMPv6 = "58"
    ALL    = "all"
  }
  security_rule_type = {
    CIDR_BLOCK             = "CIDR_BLOCK"
    SERVICE_CIDR_BLOCK     = "SERVICE_CIDR_BLOCK"
    NETWORK_SECURITY_GROUP = "NETWORK_SECURITY_GROUP"
  }
  security_rule_direction = {
    INGRESS = "INGRESS"
    EGRESS  = "EGRESS"
  }
}
