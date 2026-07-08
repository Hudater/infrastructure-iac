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
