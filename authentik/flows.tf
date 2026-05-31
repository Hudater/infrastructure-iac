data "authentik_flow" "default_authorization" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default_invalidation" {
  slug = "default-invalidation-flow"
}

# Custom enrollment flow for Google source
# Flow:
  # - email whitelist policy
  # - set username
  # - user write
  # - user login

resource "authentik_flow" "google_enrollment" {
  name        = "google-enrollment-whitelist"
  slug        = "google-enrollment-whitelist"
  title       = "Enroll via Google"
  designation = "enrollment"
}

resource "authentik_stage_user_write" "google_user_write" {
  name             = "google-user-write"
  create_users_as_inactive = false
  user_creation_mode       = "create_when_required"
  user_type                = "internal"
}

resource "authentik_stage_user_login" "google_user_login" {
  name = "google-user-login"
  session_duration = "days=180"
}

# email whitelist check

resource "authentik_policy_expression" "email_whitelist" {
  name       = "google-email-whitelist"
  expression = <<-EOT
    admin_emails    = ${jsonencode(var.admin_emails)}
    jellyfin_emails = ${jsonencode(var.jellyfin_emails)}
    immich_emails   = ${jsonencode(var.immich_emails)}
    ai_emails       = ${jsonencode(var.ai_emails)}

    all_allowed = set([e.lower() for e in admin_emails + jellyfin_emails + immich_emails + ai_emails])

    email = None
    if "pending_user" in request.context:
        email = request.context["pending_user"].email
    if not email and "prompt_data" in request.context:
        email = request.context["prompt_data"].get("email")

    if not email:
        ak_message("Could not determine email address.")
        return False

    if email.lower() not in all_allowed:
        ak_message("Your email is not authorized to access this service.")
        return False

    return True
  EOT
}

resource "authentik_policy_expression" "google_setup_user" {
  name       = "google-setup-user"
  # expression = <<-EOT
  #   from authentik.core.models import Group

  #   admin_emails    = ${jsonencode(var.admin_emails)}
  #   jellyfin_emails = ${jsonencode(var.jellyfin_emails)}
  #   immich_emails   = ${jsonencode(var.immich_emails)}
  #   ai_emails       = ${jsonencode(var.ai_emails)}

  #   email = ""
  #   if "prompt_data" in request.context:
  #       email = request.context["prompt_data"].get("email", "")
  #       if email:
  #           request.context["prompt_data"]["username"] = email.split("@")[0]

  #   groups = []

  #   if email.lower() in [e.lower() for e in admin_emails]:
  #       try:
  #           groups.append(Group.objects.get(name="users-admin"))
  #       except Group.DoesNotExist:
  #           ak_logger.warning("users-admin group not found")
  #   else:
  #       if email.lower() in [e.lower() for e in jellyfin_emails]:
  #           try:
  #               groups.append(Group.objects.get(name="users-jellyfin"))
  #           except Group.DoesNotExist:
  #               ak_logger.warning("users-jellyfin group not found")

  #       if email.lower() in [e.lower() for e in immich_emails]:
  #           try:
  #               groups.append(Group.objects.get(name="users-immich"))
  #           except Group.DoesNotExist:
  #               ak_logger.warning("users-immich group not found")

  #       if email.lower() in [e.lower() for e in ai_emails]:
  #           try:
  #               groups.append(Group.objects.get(name="users-ai"))
  #           except Group.DoesNotExist:
  #               ak_logger.warning("users-ai group not found")

  #   if groups:
  #       request.context["flow_plan"].context["groups"] = groups

  #   return True
  # EOT
  expression = <<-EOT
    from authentik.core.models import Group

    admin_emails    = ${jsonencode(var.admin_emails)}
    jellyfin_emails = ${jsonencode(var.jellyfin_emails)}
    immich_emails   = ${jsonencode(var.immich_emails)}
    ai_emails       = ${jsonencode(var.ai_emails)}

    email = ""
    if "pending_user" in request.context:
        email = getattr(request.context["pending_user"], "email", "")

    if not email and "prompt_data" in request.context:
        email = request.context["prompt_data"].get("email", "")

    if not email:
        return True

    if "prompt_data" not in request.context:
        request.context["prompt_data"] = {}
    request.context["prompt_data"]["username"] = email.split("@")[0]

    groups = []

    if email.lower() in [e.lower() for e in admin_emails]:
        try:
            groups.append(Group.objects.get(name="users-admin"))
        except Group.DoesNotExist:
            ak_logger.warning("users-admin group not found")
    if email.lower() in [e.lower() for e in jellyfin_emails]:
        try:
            groups.append(Group.objects.get(name="users-jellyfin"))
        except Group.DoesNotExist:
            ak_logger.warning("users-jellyfin group not found")

    if email.lower() in [e.lower() for e in immich_emails]:
        try:
            groups.append(Group.objects.get(name="users-immich"))
        except Group.DoesNotExist:
            ak_logger.warning("users-immich group not found")

    if email.lower() in [e.lower() for e in ai_emails]:
        try:
            groups.append(Group.objects.get(name="users-ai"))
        except Group.DoesNotExist:
            ak_logger.warning("users-ai group not found")

    if groups:
        request.context["flow_plan"].context["groups"] = groups

    return True
  EOT
}

# Bind policy 1 (whitelist) to the enrollment flow itself
# This blocks unauthorized emails before any stage runs
resource "authentik_policy_binding" "enrollment_whitelist" {
  target = authentik_flow.google_enrollment.uuid
  policy = authentik_policy_expression.email_whitelist.id
  order  = 0
}

# Bind stages to enrollment flow

# Stage binding: setup user (username + group) - order 10
resource "authentik_flow_stage_binding" "google_user_write" {
  target = authentik_flow.google_enrollment.uuid
  stage  = authentik_stage_user_write.google_user_write.id
  order  = 10
}

# # Stage binding: user write - order 20
# resource "authentik_flow_stage_binding" "user_write" {
#   target = authentik_flow.google_enrollment.uuid
#   stage  = authentik_stage_user_write.google_user_write.id
#   order  = 20
# }

# Stage binding: user login - order 30
resource "authentik_flow_stage_binding" "user_login" {
  target = authentik_flow.google_enrollment.uuid
  stage  = authentik_stage_user_login.google_user_login.id
  order  = 30
}

# Bind setup policy to user_write stage binding (runs before write)
# resource "authentik_policy_binding" "setup_user_policy" {
#   target = authentik_flow_stage_binding.user_write.id
#   policy = authentik_policy_expression.google_setup_user.id
#   order  = 0
# }
resource "authentik_policy_binding" "setup_user_policy" {
  target = authentik_flow_stage_binding.google_user_write.id
  # target = authentik_flow_stage_binding.setup_user.id
  policy = authentik_policy_expression.google_setup_user.id
  order  = 0
}

# Authentication flow for returning Google users
# Re-check whitelist on every login too
resource "authentik_flow" "google_authentication" {
  name        = "google-authentication-whitelist"
  slug        = "google-authentication-whitelist"
  title       = "Login via Google"
  designation = "authentication"
}

resource "authentik_stage_user_login" "google_auth_login" {
  name = "google-auth-login"
  session_duration = "days=180"
}

resource "authentik_flow_stage_binding" "auth_user_login" {
  target = authentik_flow.google_authentication.uuid
  stage  = authentik_stage_user_login.google_auth_login.id
  order  = 10
}

resource "authentik_policy_binding" "auth_whitelist" {
  target = authentik_flow.google_authentication.uuid
  policy = authentik_policy_expression.email_whitelist.id
  order  = 0
}

# Login page stages — shows Google button on the login form
resource "authentik_stage_password" "default_password" {
  name     = "default-login-password"
  backends = ["authentik.core.auth.InbuiltBackend"]
}

resource "authentik_stage_identification" "default_identification" {
  name               = "default-login-identification"
  user_fields        = ["email", "username"]
  password_stage     = authentik_stage_password.default_password.id
  sources            = [authentik_source_oauth.google.uuid]
  show_source_labels = true
}

resource "authentik_flow" "default_authentication" {
  name        = "Default Authentication Flow"
  slug        = "default-authentication-flow-managed"
  title       = "Welcome to authentik!"
  designation = "authentication"
}

resource "authentik_flow_stage_binding" "default_auth_identification" {
  target = authentik_flow.default_authentication.uuid
  stage  = authentik_stage_identification.default_identification.id
  order  = 10
}

# resource "authentik_flow_stage_binding" "default_auth_password" {
#   target = authentik_flow.default_authentication.uuid
#   stage  = authentik_stage_password.default_password.id
#   order  = 20
# }

resource "authentik_stage_user_login" "default_user_login" {
  name = "default-login-user-login"
  session_duration = "days=180"
}

resource "authentik_flow_stage_binding" "default_auth_user_login" {
  target = authentik_flow.default_authentication.uuid
  stage  = authentik_stage_user_login.default_user_login.id
  order  = 20
}
