# Nomad secrets backend, allows Nomad ACL tokens to be retrieved through Vault
resource "vault_nomad_secret_backend" "this" {
  backend               = var.backend_name
  description           = var.backend_description
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
  max_ttl               = var.max_ttl
  address               = var.address
  token                 = var.nomad_token
  ttl                   = var.ttl
}

# Vault roles are used to retrieve the Nomad ACL tokens
resource "vault_nomad_secret_role" "this" {
  backend  = vault_nomad_secret_backend.this.backend
  role     = var.vault_role_name # name of the vault role for acquiring nomad tokens
  type     = "client"            # vault client roles for the postgresql server
  policies = var.policies        # name of the nomad policies vault will create a token for
}
