data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "ubuntu" {
  compartment_id   = var.compartment_id
  operating_system = "Canonical Ubuntu"
  shape            = "VM.Standard.A1.Flex"
  sort_order       = "DESC"
  sort_by          = "TIMECREATED"
  filter {
    name   = "display_name"
    values = ["^.*(M|m)inimal.*$"]
    regex  = true
  }
  filter {
    name   = "operating_system_version"
    values = ["^.*(M|m)inimal.*$"]
    regex  = true
  }
}
