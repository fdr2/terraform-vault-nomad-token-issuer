terraform {
  required_version = "~>1.3.7"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.12.0"
    }
  }
}