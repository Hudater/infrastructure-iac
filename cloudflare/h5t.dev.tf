# Redirect all traffic for h5t.dev and *.h5t.dev to links.hudater.dev
# A single zone-level dynamic redirect rule covers both the apex and any subdomain

resource "cloudflare_ruleset" "h5t_dev_redirect_to_links" {
  zone_id     = var.zone_id_h5t_dev
  name        = "h5t.dev -> links.hudater.dev"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"
  description = "Redirect h5t.dev and *.h5t.dev to links.hudater.dev"

  rules {
    description = "Redirect all requests to links.hudater.dev"
    expression  = "true"
    action      = "redirect"
    enabled     = true

    action_parameters {
      from_value {
        status_code           = 301
        preserve_query_string = true

        target_url {
          value = "https://links.hudater.dev"
        }
      }
    }
  }
}