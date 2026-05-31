# Magic DNS domain  .home.lab
# DNS in LXC handles resolution, on-prem routing peer distributes it
resource "netbird_nameserver_group" "home_lab" {
  name        = "home-lab-dns"
  description = "Internal DNS for .home.lab via local dns like pihole or technitium"
  enabled     = true
  primary     = false

  nameservers = [
    {
      ip      = var.dns_ip
      ns_type = "udp"
      port    = 53
    }
  ]

  groups = [
    netbird_group.srv_onprem_noida.id,
    data.netbird_group.users_admin.id,
    data.netbird_group.users_ai.id,
    data.netbird_group.users_jellyfin.id,
    data.netbird_group.users_immich.id
  ]

  domains              = ["home.lab"]
  search_domains_enabled = true
}
