resource "cloudflare_dns_record" "OCI_BOM_ARM_domain_access" {
  comment  = "OCI Mumbai server on ARM"
  content  = var.oci-bom-arm-ip
  name     = "oci-bom-arm.${var.domain_access}"
  proxied  = false
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_BOM_AMD_1_domain_access" {
  comment  = "OCI Mumbai server 1 on x86_amd"
  content  = var.oci-bom-amd-1-ip
  name     = "oci-bom-amd-1.${var.domain_access}"
  proxied  = false
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_ZRH_ARM_domain_access" {
  comment  = "OCI Zurich server on ARM"
  content  = var.oci-zrh-arm-ip
  name     = "oci-zrh-arm.${var.domain_access}"
  proxied  = false
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_ZRH_AMD_1_domain_access" {
  comment  = "OCI Zurich server 1 on x86_amd"
  content  = var.oci-zrh-amd-1-ip
  name     = "oci-zrh-amd-1.${var.domain_access}"
  proxied  = false
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_ZRH_ARM_domain_access_traefik" {
  content  = var.oci-zrh-arm-ip
  name     = var.domain_access
  proxied  = true
  ttl      = 1
  type     = "A"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_ZRH_ARM_domain_access_wildcard_traefik" {
  content  = var.domain_access
  name     = "*.${var.domain_access}"
  proxied  = true
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_access
  settings = {}
}

resource "cloudflare_dns_record" "OCI_ZRH_ARM_domain_access_wgeasy" {
  content  = var.domain_access
  name     = "wgeasy.${var.domain_access}"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_domain_access
  settings = {}
}
