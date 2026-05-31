terraform {
  required_providers {
    netbird = {
      source  = "netbirdio/netbird"
      version = "~> 0.0.9"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "homelab_hudater"
    
    workspaces {
      name = "netbird-iac"
    }
  }
}

provider "netbird" {
  management_url = var.netbird_management_url
  token          = var.netbird_api_token
}
