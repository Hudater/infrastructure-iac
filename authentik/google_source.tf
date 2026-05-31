resource "authentik_source_oauth" "google" {
  name      = "Google"
  slug      = "google"

  provider_type   = "google"
  consumer_key    = var.google_oauth_client_id
  consumer_secret = var.google_oauth_client_secret

  # Custom flows with whitelist enforcement
  authentication_flow = authentik_flow.google_authentication.uuid
  enrollment_flow     = authentik_flow.google_enrollment.uuid

  enabled  = true
  promoted = true

  lifecycle {
    ignore_changes = [
      access_token_url,
      authorization_url,
      oidc_jwks_url,
      profile_url,
    ]
  }
}
