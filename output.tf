output "ubuntu_images" {
  value = data.oci_core_images.ubuntu.images.0
}

# output "availability_domains" {
#   value = data.oci_identity_availability_domains.availability_domains.availability_domains
# }

# output "compartments" {
#   value = data.oci_identity_compartments.compartment.compartments
# }

output "instance" {
  value = oci_core_instance.generated_oci_core_instance
}

# output "tag_namespaces" {
#   value = data.oci_identity_tag_namespaces.tag_namespaces
# }