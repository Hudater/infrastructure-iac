resource "authentik_provider_proxy" "traefik" {
  name               = "traefik-proxy"
  authorization_flow = data.authentik_flow.default_authorization.id
  invalidation_flow  = data.authentik_flow.default_invalidation.id

  mode             = "forward_domain"
  external_host    = "https://authentik.${local.domain}"
  cookie_domain    = local.domain
  access_token_validity = "hours=24"
}

resource "authentik_application" "traefik" {
  name              = "Traefik Proxy"
  slug              = "traefik-proxy"
  protocol_provider = authentik_provider_proxy.traefik.id
}

resource "authentik_outpost" "embedded" {
  name = "authentik Embedded Outpost"
  type = "proxy"

  protocol_providers = [
    authentik_provider_proxy.traefik.id,
  ]

  config = jsonencode({
    authentik_host          = var.authentik_url
    authentik_host_insecure = false
    log_level               = "info"
  })
}
