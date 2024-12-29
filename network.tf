resource "oci_core_vcn" "generated_oci_core_vcn" {
  cidr_blocks = [
    "10.0.0.0/16"
  ]
  compartment_id = var.compartment_id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "vcn-20240702-2137",
    "Resource-Tags.Type"   = "core_vcn"
  })
  display_name = "vcn-20240702-2137"
  dns_label    = "vcn07022151"
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "oci_core_subnet" "generated_oci_core_subnet" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.compartment_id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "subnet-20240702-2137",
    "Resource-Tags.Type"   = "core_subnet"
  })
  display_name   = "subnet-20240702-2137"
  dns_label      = "subnet07022151"
  route_table_id = oci_core_vcn.generated_oci_core_vcn.default_route_table_id
  vcn_id         = oci_core_vcn.generated_oci_core_vcn.id
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "oci_core_internet_gateway" "generated_oci_core_internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "Internet Gateway vcn-20240702-2137"
  enabled        = "true"
  vcn_id         = oci_core_vcn.generated_oci_core_vcn.id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "Internet Gateway vcn-20240702-2137",
    "Resource-Tags.Type"   = "core_internet_gateway"
  })
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "oci_core_default_route_table" "generated_oci_core_default_route_table" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.generated_oci_core_internet_gateway.id
  }
  manage_default_resource_id = oci_core_vcn.generated_oci_core_vcn.default_route_table_id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = oci_core_vcn.generated_oci_core_vcn.default_route_table_id,
    "Resource-Tags.Type"   = "core_default_route_table"
  })
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "oci_core_network_security_group" "network_security_group_webserver" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.generated_oci_core_vcn.id

  display_name = "WebServerSecurityGroup"
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "WebServerSecurityGroup",
    "Resource-Tags.Type"   = "core_network_security_group"
  })
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_80" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 80 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_443" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 443 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8080" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 8080 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8080
      min = 8080
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8081" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 8081 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8081
      min = 8081
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8880" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 8880 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8880
      min = 8880
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8443" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 8443 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8443
      min = 8443
    }
  }
}

resource "oci_core_network_security_group" "network_security_group_proxyserver" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.generated_oci_core_vcn.id

  display_name = "ProxyServerSecurityGroup"
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "ProxyServerSecurityGroup",
    "Resource-Tags.Type"   = "core_network_security_group"
  })
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_proxyserver_1080" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_proxyserver.id
  direction                 = local.security_rule_direction.INGRESS
  protocol                  = local.security_rule_protocles.TCP

  #Optional
  description = "Allow HTTP 1080 traffic"
  source      = "0.0.0.0/0"
  source_type = local.security_rule_type.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 1080
      min = 1080
    }
  }
}
