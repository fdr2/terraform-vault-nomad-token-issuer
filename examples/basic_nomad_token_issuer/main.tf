locals {
  test_prefix = "__test"
}

module "vault-nomad-token-issuer" {
  source       = "../../"
  nomad_token  = var.nomad_token
  backend_name = "${local.test_prefix}_nomad"
  nomad_roles  = {
    "${local.test_prefix}_nomad-ops" : {
      type : "management"
    }
    "${local.test_prefix}_nomad-server" : {
      policies : ["${local.test_prefix}_nomad-server"]
    }
  }
}

resource "vault_policy" "vault-ops" {
  name   = "${local.test_prefix}_vault-ops"
  policy = file("${path.root}/policy/vault-ops-policy.hcl")
}
