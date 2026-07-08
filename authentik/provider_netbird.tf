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
