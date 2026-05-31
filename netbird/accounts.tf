# Service Accounts
resource "netbird_user" "mcp_sa_auditor" {
  is_service_user = true
  name            = "mcp-sa-auditor"
  role            = "auditor"
}

resource "netbird_user" "iac_sa_owner" {
  is_service_user = true
  name            = "iac-sa-owner"
  role            = "admin"
}

# account Settings
resource "netbird_account_settings" "this" {
  peer_login_expiration_enabled      = false
  peer_inactivity_expiration_enabled = false
  jwt_groups_enabled                 = true
  jwt_groups_claim_name               = "groups"
  routing_peer_dns_resolution_enabled = true
  regular_users_view_blocked = true
  peer_approval_enabled = false
}
