variable "nomad_token" {
  type = string
}

variable "backend_name" {
  default = "nomad"
}

variable "backend_description" {
  default = "Managed by Terraform"
}

variable "max_lease_ttl_seconds" {
  default = 86400 # 24 hours
}

variable "max_ttl" {
  default = 36000 # 10 hours
}

variable "address" {
  default = "http://nomad.service.consul:4646"
}

variable "ttl" {
  default = 14400 # 4 hours
}

variable "vault_role_name" {
  default = "nomad-ops"
}

variable "policies" {
  type = list(string)
}
