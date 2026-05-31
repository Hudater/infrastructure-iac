variable "authentik_url" {
  type        = string
  description = "authentik API endpoint"
}

variable "authentik_token" {
  type        = string
  sensitive   = true
  description = "authentik API token"
}

variable "google_oauth_client_id" {
  type      = string
  sensitive = true
}

variable "google_oauth_client_secret" {
  type      = string
  sensitive = true
}

variable "reverse_proxy_domain" {
  type        = string
  description = "Base domain without scvheme"
}

# OAuth2 client secrets - one per app
variable "grafana_secret" {
  type      = string
  sensitive = true
}

variable "memos_secret" {
  type      = string
  sensitive = true
}

variable "oauth2_proxy_secret" {
  type      = string
  sensitive = true
}

variable "pbs_secret" {
  type      = string
  sensitive = true
}

variable "portainer_bom_arm_secret" {
  type      = string
  sensitive = true
}

variable "pve_pc_secret" {
  type      = string
  sensitive = true
}

variable "tugtainer_secret" {
  type      = string
  sensitive = true
}

variable "netbird_secret" {
  type      = string
  sensitive = true
}

variable "bom_arm_sparky_secret" {
  type      = string
  sensitive = true
}

# Allowed emails for Google login whitelist (comma-separated 

variable "admin_emails" {
  type        = list(string)
  description = "Full access. auto-assign to users-admin"
  default     = []
}

variable "jellyfin_emails" {
  type        = list(string)
  description = "Jellyfin access. auto-assign to users-jellyfin"
  default     = []
}

variable "immich_emails" {
  type        = list(string)
  description = "Immich access. auto-assign to users-immich"
  default     = []
}

variable "ai_emails" {
  type        = list(string)
  description = "AI services access. auto-assign to users-ai"
  default     = []
}
