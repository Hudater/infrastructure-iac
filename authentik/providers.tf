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
data "authentik_property_mapping_provider_scope" "entitlements" {
  managed = "goauthentik.io/providers/oauth2/scope-entitlements"
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

  logout_uri    = "https://grafana.${local.domain}/logout"
  logout_method = "frontchannel"

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
    data.authentik_property_mapping_provider_scope.entitlements.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "grafana" {
  name              = "Grafana"
  slug              = "grafana"
  protocol_provider = authentik_provider_oauth2.grafana.id
}

resource "authentik_application_entitlement" "grafana_admins" {
  name        = "Grafana Admins"
  application = authentik_application.grafana.uuid
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

## Portainer
resource "authentik_provider_oauth2" "portainer_bom_arm" {
  name          = "portainer-bom-arm"
  client_id     = "portainer_bom-arm"
  client_secret = var.portainer_bom_arm_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  logout_uri = "https://portainer.${local.domain}/"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://portainer.${local.domain}/"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    data.authentik_property_mapping_provider_scope.entitlements.id,
    authentik_property_mapping_provider_scope.groups.id,
  ]
}

resource "authentik_application" "portainer_bom_arm" {
  name              = "Portainer"
  slug              = "portainer-bom-arm"
  protocol_provider = authentik_provider_oauth2.portainer_bom_arm.id
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

  authorization_flow     = data.authentik_flow.default_authorization.id
  invalidation_flow      = data.authentik_flow.default_invalidation.id
  signing_key            = data.authentik_certificate_key_pair.default.id
  access_token_validity  = "days=30"
  refresh_token_validity = "days=365"
  logout_uri             = "https://netbird.${local.domain}/oauth2/logout/callback"

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
