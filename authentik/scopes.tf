# Property mapping to inject groups claim into tokens
# Equivalent to Keycloak's group membership protocol mapper
resource "authentik_property_mapping_provider_scope" "groups" {
  name       = "groups"
  scope_name = "groups"
  description = "Group membership claim"
  expression = <<-EOT
    return [group.name for group in request.user.ak_groups.all()]
  EOT
}
