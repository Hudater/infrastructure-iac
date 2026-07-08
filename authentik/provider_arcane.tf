resource "authentik_provider_oauth2" "arcane_bom_arm" {
  name          = "arcane-bom-arm"
  client_id     = "arcane_bom-arm"
  # client_secret = var.arcane_bom_arm_secret

  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id
  signing_key        = data.authentik_certificate_key_pair.default.id

  logout_uri = "https://arcane.${local.domain}/"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://arcane.${local.domain}/auth/oidc/callback"
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

resource "authentik_application" "arcane_bom_arm" {
  name              = "arcane"
  slug              = "arcane-bom-arm"
  protocol_provider = authentik_provider_oauth2.arcane_bom_arm.id
}
