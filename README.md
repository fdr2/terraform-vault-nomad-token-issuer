# Terraform Vault Nomad Token Issuer

Configure Vault's Nomad Credential Engine with Nomad.

Issues a Nomad token with the attached Nomad policy.

> This module aligns with [Vault Integration and Retrieving Dynamic Secrets](https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-postgres#vault-postgres)

## Usage
Add the module and assign a nomad policy for the tokens that will be issued.

```terraform
module "vault-nomad-token-issuer" {
  source       = "app.terraform.io/DiRoccos/nomad-token-issuer/vault"
  nomad_token  = var.nomad_token
  backend_name = "nomad"
  nomad_roles  = {
    "nomad-ops" : {
      type : "management"
    }
    "nomad-server" : {
      policies : ["nomad-server"]
    }
  }
}

resource "nomad_policy" "nomad-server" {
  name     = "nomad-server"
  policy   = file("policies/nomad-server.hcl")
}
```

## Contributors Prerequisites

Terraform Code Utilities
```bash
brew tap liamg/tfsec
brew install terraform-docs tflint tfsec checkov
brew install pre-commit gawk coreutils go
```

Add the following to your `~/.profile`, if it is not already there.
You can check if they already exist by executing `env`.
```bash
# Go
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
```

Then reload your profile.
```bash
. ~/.profile
```

Ensure `golint` is properly installed with PATHs set properly from above.
```bash
go get -u golang.org/x/lint/golint
```

To manually run the pre-commit hooks
```bash
pre-commit run -a
```

### Tests
Login to Vault or issue a runner a VAULT_TOKEN environment variable.
```bash
VAULT_HOST=https://vault.service.consul:8200 vault login -method=ldap username=$USER
```

Ensure you have Go >= 1.19.5
[Read more about terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
```bash
cd test/main
go test
```

## TODO
