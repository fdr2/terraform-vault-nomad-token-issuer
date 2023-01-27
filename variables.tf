variable "nomad_token" {
  type = string
}

variable "backend_name" {
  type    = string
  default = "nomad"
}

variable "backend_description" {
  type    = string
  default = "Managed by Terraform"
}

variable "disable_remount" {
  default = false
}

variable "default_lease_ttl_seconds" {
  default = null
}

variable "max_lease_ttl_seconds" {
  type    = number
  default = null
}

variable "address" {
  type    = string
  default = "https://nomad.service.consul:4646"
}

variable "nomad_ca_cert" {
  default = null
}

variable "nomad_client_cert" {
  default = null
}

variable "nomad_client_key" {
  default = null
}

variable "nomad_roles" {
  type    = any
  default = null
}
