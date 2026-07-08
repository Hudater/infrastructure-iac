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
