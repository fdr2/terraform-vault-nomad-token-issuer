terraform {
  required_version = "~>1.4.5"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.12.0"
    }
  }
}