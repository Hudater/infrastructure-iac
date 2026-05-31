terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2026.2.0"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "homelab_hudater"
    
    workspaces {
      name = "authentik-iac"
    }
  }
}

provider "authentik" {
  url   = var.authentik_url
  token = var.authentik_token
}
