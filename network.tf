resource "oci_core_vcn" "generated_oci_core_vcn" {
  cidr_block     = "10.0.0.0/16"
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
