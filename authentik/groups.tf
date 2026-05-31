resource "authentik_group" "users_admin" {
  name         = "users-admin"
  is_superuser = true
}

resource "authentik_group" "users_jellyfin" {
  name         = "users-jellyfin"
  is_superuser = false
}

resource "authentik_group" "users_immich" {
  name         = "users-immich"
  is_superuser = false
}

resource "authentik_group" "users_ai" {
  name         = "users-ai"
  is_superuser = false
}
