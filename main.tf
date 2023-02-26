# Nomad secrets backend, allows Nomad ACL tokens to be retrieved through Vault
resource "vault_nomad_secret_backend" "this" {
  backend                   = var.backend_name
  description               = var.backend_description
  disable_remount           = var.disable_remount
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_ttl                   = var.max_ttl
  ttl                       = var.ttl
  address                   = var.address
  token                     = var.nomad_token
  ca_cert                   = var.nomad_ca_cert
  client_cert               = var.nomad_client_cert
  client_key                = var.nomad_client_key
}

# Vault roles are used to retrieve the Nomad ACL tokens
resource "vault_nomad_secret_role" "this" {
  for_each = var.nomad_roles
  backend  = vault_nomad_secret_backend.this.backend
  role     = each.key
  type     = try(each.value["type"], "client")
  policies = try(each.value["policies"], null)
}
