locals {
  github_pages_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]

  gh_pages_subdomains = [
    "blog",
    "cohort",
    "docs",
    "links",
    "staging",
    "talwinder",
    "www",
    "archive-docs"
  ]
}

# Apex record for GitHub Pages
resource "cloudflare_dns_record" "hudater_dev_apex" {
  for_each = toset(local.github_pages_ips)
  name     = "hudater.dev"
  content  = each.value
  type     = "A"
  ttl      = 300
  proxied  = false
  zone_id  = var.zone_id_hudater_dev
}

# Subdomains for GitHub Pages
resource "cloudflare_dns_record" "hudater_dev_subdomains" {
  for_each = toset(local.gh_pages_subdomains)
  name     = "${each.value}.hudater.dev"
  content  = "hudater.github.io"
  type     = "CNAME"
  ttl      = 300
  proxied  = false
  zone_id  = var.zone_id_hudater_dev
}
# Public status page
resource "cloudflare_dns_record" "satus_hudater_dev" {
  comment  = "Status page for whole infrastructure"
  content  = "${var.domain_lab}"
  name     = "status.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

# NOTE: handled in resume-pipeline repo now
# Resume pipeline
# resource "cloudflare_dns_record" "resume_hudater_dev" {
#   comment  = "Resume pipeline page"
#   content  = "workers.dev"
#   name     = "resume.hudater.dev"
#   proxied  = true
#   ttl      = 1
#   type     = "CNAME"
#   zone_id  = var.zone_id_hudater_dev
#   settings = {}
# }

resource "cloudflare_dns_record" "hashnode_hudater_dev" {
  content  = "hashnode.network"
  name     = "hashnode.hudater.dev"
  proxied  = false
  ttl      = 300
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

# mail
resource "cloudflare_dns_record" "mail_return_hudater_dev" {
  content  = "return.smtp2go.net"
  name     = "em1369722.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_link_hudater_dev" {
  content  = "track.smtp2go.net"
  name     = "link.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_dkim_hudater_dev" {
  content  = "dkim.smtp2go.net"
  name     = "s1369722._domainkey.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_mailgun_hudater_dev" {
  content  = "mailgun.org"
  name     = "email.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "CNAME"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_route_3_hudater_dev" {
  content  = "mxa.mailgun.org"
  name     = "hudater.dev"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_route_2_hudater_dev" {
  content  = "mxb.mailgun.org"
  name     = "hudater.dev"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_dkim_txt_hudater_dev" {
  content  = "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7CghGTlzDKEC401kWOEB3Oj4tNS6B8nSzVF4pbXZry2PnQLSlQbc2qMQb+kKfNPmS3C5956HY6IquOk52nD6OKlnrGneUY5+U78QxTy4CVTvFKbTmS2iALrB/vfPKYzmGlol/RRczDZa2pMwf4goc19XNUrOCv8+XOvKStxohdQIDAQAB\""
  name     = "smtp._domainkey.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_dmarc_txt_hudater_dev" {
  comment  = "DMARC for mail"
  content  = "\"v=DMARC1; p=none; pct=100; fo=1; ri=3600; rua=mailto:d8e40f9a@dmarc.mailgun.org,mailto:25d0ce1f@inbox.ondmarc.com; ruf=mailto:d8e40f9a@dmarc.mailgun.org,mailto:25d0ce1f@inbox.ondmarc.com;\""
  name     = "_dmarc.hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}

resource "cloudflare_dns_record" "mail_spf_txt_hudater_dev" {
  content  = "\"v=spf1 include:_spf.smtp2go.com include:mailgun.org ~all\""
  name     = "hudater.dev"
  proxied  = false
  ttl      = 1
  type     = "TXT"
  zone_id  = var.zone_id_hudater_dev
  settings = {}
}
