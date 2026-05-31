resource "authentik_policy_expression" "require_admin" {
  name       = "require-group-admin"
  expression = "return request.user.ak_groups.filter(name='users-admin').exists()"
}

resource "authentik_policy_expression" "require_jellyfin" {
  name       = "require-group-jellyfin"
  expression = <<-EOT
    return (
      request.user.ak_groups.filter(name="users-jellyfin").exists() or
      request.user.ak_groups.filter(name="users-admin").exists()
    )
  EOT
}

resource "authentik_policy_expression" "require_immich" {
  name       = "require-group-immich"
  expression = <<-EOT
    return (
      request.user.ak_groups.filter(name="users-immich").exists() or
      request.user.ak_groups.filter(name="users-admin").exists()
    )
  EOT
}

resource "authentik_policy_expression" "require_ai" {
  name       = "require-group-ai"
  expression = <<-EOT
    return (
      request.user.ak_groups.filter(name="users-ai").exists() or
      request.user.ak_groups.filter(name="users-admin").exists()
    )
  EOT
}

# App bindings admin only
resource "authentik_policy_binding" "grafana_admin" {
  target = authentik_application.grafana.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "pbs_admin" {
  target = authentik_application.pbs.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "portainer_admin" {
  target = authentik_application.portainer_bom_arm.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "pve_admin" {
  target = authentik_application.pve_pc.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "tugtainer_admin" {
  target = authentik_application.tugtainer.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "sparky_admin" {
  target = authentik_application.bom_arm_sparky.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
resource "authentik_policy_binding" "memos_admin" {
  target = authentik_application.memos.uuid
  policy = authentik_policy_expression.require_admin.id
  order  = 0
}
