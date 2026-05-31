output "apps" {
  description = "OAuth2 apps configured in authentik"
  value = {
    grafana = {
      client_id    = authentik_provider_oauth2.grafana.client_id
      redirect_uri = "https://grafana.${local.domain}/login/generic_oauth"
    }
    memos = {
      client_id    = authentik_provider_oauth2.memos.client_id
      redirect_uri = "https://memos.${local.domain}/auth/callback"
    }
    oauth2_proxy = {
      client_id    = authentik_provider_oauth2.oauth2_proxy.client_id
      redirect_uri = "https://auth.${local.domain}/oauth2/callback"
    }
    pbs = {
      client_id    = authentik_provider_oauth2.pbs.client_id
      redirect_uri = "https://pbs.${local.domain}"
    }
    portainer = {
      client_id    = authentik_provider_oauth2.portainer_bom_arm.client_id
      redirect_uri = "https://portainer.${local.domain}/.*"
    }
    pve_pc = {
      client_id    = authentik_provider_oauth2.pve_pc.client_id
      redirect_uri = "https://pve-pc.${local.domain}"
    }
    tugtainer = {
      client_id    = authentik_provider_oauth2.tugtainer.client_id
      redirect_uri = "https://tugtainer.${local.domain}/api/auth/oidc/callback"
    }
    netbird = {
      client_id     = authentik_provider_oauth2.netbird.client_id
      redirect_uris = [
        "https://netbird.${local.domain}/nb-auth",
        "https://netbird.${local.domain}/nb-silent-auth",
        "http://localhost:53000/",
      ]
    }
    sparky = {
      client_id    = authentik_provider_oauth2.bom_arm_sparky.client_id
      redirect_uri = "https://sparky.${local.domain}/oidc-callback"
    }
  }
}

output "google_source_callback" {
  description = "Google OAuth callback URI — register this in Google Cloud Console"
  value       = authentik_source_oauth.google.callback_uri
}

output "groups" {
  description = "Groups configured for role-based access"
  value = {
    admin  = authentik_group.users_admin.name
    jellyfin = authentik_group.users_jellyfin.name
    immich   = authentik_group.users_immich.name
    ai       = authentik_group.users_ai.name
  }
}

output "oidc_configuration" {
  description = "OIDC well-known URL for any app to discover endpoints"
  value       = "${var.authentik_url}/application/o/.well-known/openid-configuration"
}
