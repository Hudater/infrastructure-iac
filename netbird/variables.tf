variable "netbird_management_url" {
  type    = string
}

variable "netbird_api_token" {
  type      = string
  sensitive = true
}

variable "dns_ip" {
  type        = string
  description = "DNS LXC IP for .home.lab DNS resolution"
  default     = "10.2.0.7" # REPLACE with actual Pihole or technitium ip
}

variable "reverse_proxy_domain" {
  type        = string
  description = "Root domain for reverse proxy"
}

variable "authentik_client_secret" {
  type        = string
  description = "Client secret for the Authentik OIDC provider"
  sensitive   = true
}
