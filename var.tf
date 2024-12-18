variable "terraform_version" {
  description = "terraform version, run source ./pre_init.sh in shell before running terraform"
  default     = "undefined"
}
variable "region" {
  description = "name of region"
}
variable "compartment_id" {
  description = "ocid of the compartment"
}
variable "ssh_authorized_keys" {
  description = "used for instance ssh access"
}
variable "user_data" {
  description = "user script to run on instance"
}