locals {
  pre_defined_tags = {
    "Operation-Tags.CreatedBy"        = "Terraform"
    "Operation-Tags.TerraformVersion" = var.terraform_version
    "Resource-Tags.Region"            = var.region
  }
  security_rule_protocols = {
    TCP    = "6"
    UDP    = "17"
    ICMP   = "1"
    ICMPv6 = "58"
    ALL    = "all"
  }
  security_rule_types = {
    CIDR_BLOCK             = "CIDR_BLOCK"
    SERVICE_CIDR_BLOCK     = "SERVICE_CIDR_BLOCK"
    NETWORK_SECURITY_GROUP = "NETWORK_SECURITY_GROUP"
  }
  security_rule_directions = {
    INGRESS = "INGRESS"
    EGRESS  = "EGRESS"
  }
  cidr_blocks = {
    ALL_TRAFFIC        = "0.0.0.0/0"
    ALL_TRAFFIC_IPV6   = "::/0"
  }
  route_destination_types = {
    CIDR_BLOCK         = "CIDR_BLOCK"
    SERVICE_CIDR_BLOCK = "SERVICE_CIDR_BLOCK"
  }
}
