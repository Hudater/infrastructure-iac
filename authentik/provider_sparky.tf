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
