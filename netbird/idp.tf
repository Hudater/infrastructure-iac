# Authentik OIDC Identity Provider

resource "netbird_identity_provider" "authentik" {
  type          = "oidc"
  name          = "Authentik"
  client_id     = "netbird"
  client_secret = var.authentik_client_secret
  issuer        = "https://authentik.${var.reverse_proxy_domain}/application/o/netbird/"
}
