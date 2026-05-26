resource "cloudflare_dns_record" "OCI_BOM_ARM_domain_lab_traefik" {
  content  = var.oci-bom-arm-ip
  name     = var.domain_lab
  proxied  = true
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_lab
  settings = {}
}

resource "cloudflare_dns_record" "OCI_BOM_ARM_wildcard_domain_lab_traefik" {
  content  = var.domain_lab
  name     = "*.${var.domain_lab}"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_lab
  settings = {}
}

resource "cloudflare_dns_record" "headscale_domain_lab" {
  comment  = "Headscale not proxied due to connection error"
  content  = var.domain_lab
  name     = "headscale.${var.domain_lab}"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_lab
  settings = {}
}

resource "cloudflare_dns_record" "netbird_domain_lab" {
  content  = var.domain_lab
  name     = "netbird.${var.domain_lab}"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_lab
  settings = {}
}

resource "cloudflare_dns_record" "netbird_rp_domain_lab" {
  content  = var.domain_lab
  name     = "*.netbird.${var.domain_lab}"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_lab
  settings = {}
}
