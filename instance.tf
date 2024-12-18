resource "oci_core_instance" "generated_oci_core_instance" {
  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "ENABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  availability_config {
    is_live_migration_preferred = "true"
    recovery_action             = "RESTORE_INSTANCE"
  }
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains.0.name
  compartment_id      = var.compartment_id
  create_vnic_details {
    assign_ipv6ip             = "false"
    assign_private_dns_record = "true"
    assign_public_ip          = "true"
    subnet_id                 = oci_core_subnet.generated_oci_core_subnet.id
  }
  defined_tags = merge(local.pre_defined_tags, {
    "Resource-Tag.Family" = "Core",
    "Resource-Tag.Name"   = "instance-default",
    "Resource-Tag.Type"  = "core_instance"
  })
  display_name = "instance-default"
  instance_options {
    are_legacy_imds_endpoints_disabled = "true"
  }
  metadata = {
    "user_data"           = base64encode(var.user_data)
    "ssh_authorized_keys" = var.ssh_authorized_keys
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = "24"
    ocpus         = "4"
  }
  source_details {
    boot_volume_size_in_gbs = "200"
    boot_volume_vpus_per_gb = "120"
    source_id               = data.oci_core_images.ubuntu.images.0.id
    source_type             = "image"
  }

  lifecycle {
    ignore_changes = [
      source_details.0.source_id,
      defined_tags,
      freeform_tags
    ]
  }
}
