resource "oci_core_vcn" "generated_oci_core_vcn" {
  cidr_blocks = [
    var.vcn_cidr
  ]
  compartment_id = var.compartment_id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "vcn-20240702-2137",
    "Resource-Tags.Type"   = "core_vcn"
  })
  display_name                     = "vcn-20240702-2137"
  dns_label                        = "vcn07022151"
  is_ipv6enabled                   = true
  is_oracle_gua_allocation_enabled = true
  lifecycle {
    ignore_changes = [
      # Ignore changes to is_oracle_gua_allocation_enabled to avoid unnecessary updates
      # https://github.com/oracle/terraform-provider-oci/issues/2215
      is_oracle_gua_allocation_enabled
    ]
  }
}

resource "oci_core_security_list" "security_list_on_premises" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.generated_oci_core_vcn.id

  #Optional
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "Security List for On-Premises",
    "Resource-Tags.Type"   = "core_security_list"
  })
  display_name = "Security List for On-Premises"
  egress_security_rules {
    #Required
    destination = var.on_premises_cidr
    protocol    = local.security_rule_protocols.TCP

    #Optional
    description      = "allows outgoing TCP traffic on all ports to an on-premises network"
    destination_type = local.security_rule_types.CIDR_BLOCK
    stateless        = false
  }
  ingress_security_rules {
    #Required
    protocol = local.security_rule_protocols.TCP
    source   = var.on_premises_cidr

    #Optional
    description = "allows incoming SSH on TCP port 22 from an on-premises network"
    source_type = local.security_rule_types.CIDR_BLOCK
    stateless   = false
    tcp_options {

      #Optional
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    #Required
    protocol = local.security_rule_protocols.TCP
    source   = var.on_premises_cidr

    #Optional
    description = "allows incoming Web Proxy on TCP port 1080 from an on-premises network"
    source_type = local.security_rule_types.CIDR_BLOCK
    stateless   = false
    tcp_options {

      #Optional
      max = 1080
      min = 1080
    }
  }
  ingress_security_rules {
    #Required
    protocol = local.security_rule_protocols.ICMP
    source   = var.on_premises_cidr

    #Optional
    description = "allows incoming ICMP calls from an on-premises network"
    source_type = local.security_rule_types.CIDR_BLOCK
    stateless   = false
  }
}

resource "oci_core_subnet" "generated_oci_core_subnet" {
  cidr_block     = var.subnet_cidr
  compartment_id = var.compartment_id
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "subnet-20240702-2137",
    "Resource-Tags.Type"   = "core_subnet"
  })
  display_name      = "subnet-20240702-2137"
  dns_label         = "subnet07022151"
  security_list_ids = [oci_core_security_list.security_list_on_premises.id]
  route_table_id    = oci_core_vcn.generated_oci_core_vcn.default_route_table_id
  vcn_id            = oci_core_vcn.generated_oci_core_vcn.id
  ipv6cidr_block    = cidrsubnet(oci_core_vcn.generated_oci_core_vcn.ipv6cidr_blocks.0, 64 - substr(oci_core_vcn.generated_oci_core_vcn.ipv6cidr_blocks.0, -2, -1), 0)
  ipv6cidr_blocks   = [for cidr in oci_core_vcn.generated_oci_core_vcn.ipv6cidr_blocks : cidrsubnet(cidr, 64 - substr(cidr, -2, -1), 0)]
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

resource "oci_core_drg" "drg_site_to_site_vpn" {
  compartment_id = var.compartment_id
  display_name   = "Dynamic Routing Gateway Site-to-Site-VPN"
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tags.Family" = "Core",
    "Resource-Tags.Name"   = "Dynamic Routing Gateway Site-to-Site-VPN",
    "Resource-Tags.Type"   = "core_drg"
  })
}

resource "oci_core_default_route_table" "generated_oci_core_default_route_table" {
  route_rules {
    destination       = var.on_premises_cidr
    destination_type  = local.route_destination_types.CIDR_BLOCK
    network_entity_id = oci_core_drg.drg_site_to_site_vpn.id
  }
  route_rules {
    destination       = local.cidr_blocks.ALL_TRAFFIC
    destination_type  = local.route_destination_types.CIDR_BLOCK
    network_entity_id = oci_core_internet_gateway.generated_oci_core_internet_gateway.id
  }
  route_rules {
    destination       = local.cidr_blocks.ALL_TRAFFIC_IPV6
    destination_type  = local.route_destination_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 80 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_80v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 80 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 443 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_443v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 443 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8080 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8080
      min = 8080
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8080v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8080 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8081 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8081
      min = 8081
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8081v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8081 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8880 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8880
      min = 8880
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8880v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8880 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8443 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 8443
      min = 8443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_webserver_8443v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_webserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 8443 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
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
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 1080 traffic"
  source      = var.on_premises_cidr
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 1080
      min = 1080
    }
  }
}

/*
resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_proxyserver_1080v6" {
  #Required
  network_security_group_id = oci_core_network_security_group.network_security_group_proxyserver.id
  direction                 = local.security_rule_directions.INGRESS
  protocol                  = local.security_rule_protocols.TCP

  #Optional
  description = "Allow HTTP 1080 traffic"
  source      = local.cidr_blocks.ALL_TRAFFIC_IPV6
  source_type = local.security_rule_types.CIDR_BLOCK
  stateless   = false
  tcp_options {
    destination_port_range {
      max = 1080
      min = 1080
    }
  }
}
*/

