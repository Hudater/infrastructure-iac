variable "domain_lab" {
  description = "Homelab domain"
  type        = string
  sensitive   = true
}

variable "domain_access" {
  description = "Access domain for SSH etc"
  type        = string
  sensitive   = true
}

## Zone IDs
variable "zone_id_domain_access" {
  description = "Zone ID for specific domains on cloudflare"
  type        = string
  sensitive   = true
}

variable "zone_id_devop_ing" {
  description = "Zone ID for specific domains on cloudflare"
  type        = string
  sensitive   = true
}

variable "zone_id_hudater_dev" {
  description = "Zone ID for specific domains on cloudflare"
  type        = string
  sensitive   = true
}

variable "zone_id_domain_lab" {
  description = "Zone ID for specific domains on cloudflare"
  type        = string
  sensitive   = true
}

## IP Addresses
variable "oci-bom-arm-ip" {
  description = "IP Address for specific servers"
  type        = string
  sensitive   = true
}

variable "oci-bom-amd-1-ip" {
  description = "IP Address for specific servers"
  type        = string
  sensitive   = true
}

variable "oci-zrh-arm-ip" {
  description = "IP Address for specific servers"
  type        = string
  sensitive   = true
}

variable "oci-zrh-amd-1-ip" {
  description = "IP Address for specific servers"
  type        = string
  sensitive   = true
}

# variable "oci-zrh-amd-2-ip" {
#   description = "IP Address for specific servers"
#   type        = string
#   sensitive   = true
# }

## Misc
variable "cf_zone_dns_api_token" {
  description = "API Token to edit zone DNS"
  type        = string
  sensitive   = true
}

variable "cf_global_api_key" {
  description = "Global API Key for CF"
  type        = string
  sensitive   = true
}

variable "cf_edit_all_api_token" {
  description = "API Token to Edit All settings"
  type        = string
  sensitive   = true
}

variable "cf_email_api_token" {
  description = "API Token to Edit mail and DMARC settings"
  type        = string
  sensitive   = true
}

variable "cf_account_id" {
  description = "Account ID from CF"
  type        = string
  sensitive   = true
}

## Emails
variable "mail_gmail_dest" {
  description = "Destination mail at gmail.com"
  type        = string
  sensitive   = true
}

variable "mail_admin_haops" {
  description = "Haops admin mail"
  type        = string
  sensitive   = true
}

variable "mail_harshit_hudater" {
  description = "Hudater.dev professional mail"
  type        = string
  sensitive   = true
}
