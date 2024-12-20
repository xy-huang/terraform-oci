output "ubuntu_images" {
  value = data.oci_core_images.ubuntu.images.0
}

output "instance" {
  value = oci_core_instance.generated_oci_core_instance
}
