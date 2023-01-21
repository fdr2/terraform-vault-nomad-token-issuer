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

variable "max_lease_ttl_seconds" {
  type    = number
  default = 86400 # 24 hours
}

variable "max_ttl" {
  type    = number
  default = 36000 # 10 hours
}

variable "address" {
  type    = string
  default = "http://nomad.service.consul:4646"
}

variable "ttl" {
  type    = number
  default = 14400 # 4 hours
}

variable "vault_role_name" {
  type    = string
  default = "nomad-ops"
}

variable "policies" {
  type = list(string)
}
