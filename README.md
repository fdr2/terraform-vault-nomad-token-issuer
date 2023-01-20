# Terraform Vault Nomad Token Issuer

Configure Vault's Nomad Credential Engine with Nomad.

Issues a Nomad token with the attached Nomad policy.

> This module aligns with [Vault Integration and Retrieving Dynamic Secrets](https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-postgres#vault-postgres)

## Usage
Add the module and assign a nomad policy for the tokens that will be issued.

```terraform
module "vault-nomad-token-issuer" {
  source      = "./modules/terraform-vault-nomad-token-issuer"
  nomad_token = var.nomad_token
  policies    = ["nomad-ops"]
}

resource "vault_policy" "nomad-ops" {
  name     = "nomad-ops"
  policy   = file("policies/nomad-ops.hcl")
}
```

## TODO

* write local vault dev example
* write tests

