resource "authentik_brand" "default" {
  domain              = "authentik-default"
  default             = true
  branding_title      = "authentik"
  flow_authentication = authentik_flow.default_authentication.uuid
  flow_invalidation   = data.authentik_flow.default_invalidation.id

  lifecycle {
    ignore_changes = [
      branding_logo,
      branding_favicon,
    ]
  }
}
