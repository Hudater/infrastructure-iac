data "authentik_certificate_key_pair" "default" {
  name = "authentik Self-signed Certificate"
}

data "authentik_property_mapping_provider_scope" "openid" {
  managed = "goauthentik.io/providers/oauth2/scope-openid"
}
data "authentik_property_mapping_provider_scope" "email" {
  managed = "goauthentik.io/providers/oauth2/scope-email"
}
data "authentik_property_mapping_provider_scope" "profile" {
  managed = "goauthentik.io/providers/oauth2/scope-profile"
}

locals {
  domain = var.reverse_proxy_domain
}

## Grafana
resource "authentik_provider_oauth2" "grafana" {
  name          = "grafana"
  client_id     = "grafana"
  client_secret = var.grafana_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://grafana.${local.domain}/login/generic_oauth"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id
  ]
}

resource "authentik_application" "grafana" {
  name              = "Grafana"
  slug              = "grafana"
  protocol_provider = authentik_provider_oauth2.grafana.id
}

## Memos
resource "authentik_provider_oauth2" "memos" {
  name          = "memos"
  client_id     = "memos"
  client_secret = var.memos_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://memos.${local.domain}/auth/callback"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "memos" {
  name              = "Memos"
  slug              = "memos"
  protocol_provider = authentik_provider_oauth2.memos.id
}

## Oauth2-proxy
resource "authentik_provider_oauth2" "oauth2_proxy" {
  name          = "oauth2-proxy"
  client_id     = "oauth2-proxy"
  client_secret = var.oauth2_proxy_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://auth.${local.domain}/oauth2/callback"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "oauth2_proxy" {
  name              = "OAuth2 Proxy"
  slug              = "oauth2-proxy"
  protocol_provider = authentik_provider_oauth2.oauth2_proxy.id
}

## Proxmox Backup Server
resource "authentik_provider_oauth2" "pbs" {
  name          = "pbs"
  client_id     = "pbs"
  client_secret = var.pbs_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://pbs.${local.domain}"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "pbs" {
  name              = "Proxmox Backup Server"
  slug              = "pbs"
  protocol_provider = authentik_provider_oauth2.pbs.id
}

## Portainer
resource "authentik_provider_oauth2" "portainer_bom_arm" {
  name          = "portainer-bom-arm"
  client_id     = "portainer_bom-arm"
  client_secret = var.portainer_bom_arm_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "regex"
      url           = "https://portainer.${local.domain}/.*"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "portainer_bom_arm" {
  name              = "Portainer"
  slug              = "portainer-bom-arm"
  protocol_provider = authentik_provider_oauth2.portainer_bom_arm.id
}

## Proxmox whatever VE stands for
# the pc one, "prod"
resource "authentik_provider_oauth2" "pve_pc" {
  name          = "pve-pc"
  client_id     = "pve-pc"
  client_secret = var.pve_pc_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://pve-pc.${local.domain}"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "pve_pc" {
  name              = "Proxmox VE"
  slug              = "pve-pc"
  protocol_provider = authentik_provider_oauth2.pve_pc.id
}

## Tugtainer
resource "authentik_provider_oauth2" "tugtainer" {
  name          = "tugtainer"
  client_id     = "tugtainer"
  client_secret = var.tugtainer_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://tugtainer.${local.domain}/api/auth/oidc/callback"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "tugtainer" {
  name              = "Tugtainer"
  slug              = "tugtainer"
  protocol_provider = authentik_provider_oauth2.tugtainer.id
}

## Netbird
resource "authentik_provider_oauth2" "netbird" {
  name          = "netbird"
  client_id     = "netbird"
  client_secret = var.netbird_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id
  access_token_validity  = "hours=24"
  refresh_token_validity = "days=180"
  logout_uri = "https://netbird.${local.domain}/"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://netbird.${local.domain}/oauth2/callback"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "netbird" {
  name              = "Netbird"
  slug              = "netbird"
  protocol_provider = authentik_provider_oauth2.netbird.id
}

## Sparky
resource "authentik_provider_oauth2" "bom_arm_sparky" {
  name          = "bom-arm-sparky"
  client_id     = "bom-arm_sparky"
  client_secret = var.bom_arm_sparky_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://sparky.${local.domain}/oidc-callback"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "bom_arm_sparky" {
  name              = "Sparky"
  slug              = "bom-arm-sparky"
  protocol_provider = authentik_provider_oauth2.bom_arm_sparky.id
}
