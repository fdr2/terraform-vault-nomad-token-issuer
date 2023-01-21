locals {
  test_prefix = "__test"
}

module "vault-nomad-token-issuer" {
  source       = "../../"
  nomad_token  = var.nomad_token
  policies     = ["${local.test_prefix}/nomad-ops"]
  backend_name = "${local.test_prefix}/nomad"
}

resource "vault_policy" "vault-ops" {
  name   = "${local.test_prefix}/vault-ops"
  policy = file("${path.root}/policy/vault-ops-policy.hcl")
}
