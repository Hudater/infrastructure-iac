# Technitium HA Cluster DNS
# Primary DNS for client peers with .lan resolution and ad-blocking
resource "netbird_nameserver_group" "technitium_cluster" {
  name        = "technitium-cluster"
  description = "Primary DNS for all traffic via Technitium HA cluster (with ad-blocking)"
  enabled     = true
  primary     = true

  nameservers = [
    {
      ip      = "10.2.0.7"     # On-prem Technitium (Primary)
      ns_type = "udp"
      port    = 53
    },
    {
      ip      = "10.70.0.103"  # OCI bom-arm Technitium (Secondary)
      ns_type = "udp"
      port    = 53
    }
  ]

  groups = [
    data.netbird_group.users_admin.id,
    data.netbird_group.users_ai.id,
    data.netbird_group.users_jellyfin.id,
    data.netbird_group.users_immich.id
  ]

  domains                = []
  search_domains_enabled = false
}
