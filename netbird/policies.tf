# Admin Policy 
# Admins get full access to all server groups, all protocol, bidirectional
resource "netbird_policy" "admin_full_access" {
  name        = "admin-full-access"
  description = "Admins have full access to all infra and services"
  enabled     = true

  rule {
    name          = "admin-to-infra-all"
    action        = "accept"
    bidirectional = true
    enabled       = true
    protocol      = "all"
    sources = [
      data.netbird_group.users_admin.id,
    ]
    destinations = [
      netbird_group.srv_onprem_noida.id,
      netbird_group.srv_oci_bom.id,
      netbird_group.srv_oci_zrh.id,
    ]
  }
}

# Server full mesh all servers talk to each other
resource "netbird_policy" "srv_full_mesh" {
  name        = "srv-full-mesh"
  description = "All servers can communicate with each other"
  enabled     = true

  rule {
    name          = "srv-full-mesh"
    action        = "accept"
    bidirectional = true
    enabled       = true
    protocol      = "all"
    sources = [
      netbird_group.srv_onprem_noida.id,
      netbird_group.srv_oci_bom.id,
      netbird_group.srv_oci_zrh.id,
    ]
    destinations = [
      netbird_group.srv_onprem_noida.id,
      netbird_group.srv_oci_bom.id,
      netbird_group.srv_oci_zrh.id,
    ]
  }
}

# SSH - admins only
resource "netbird_policy" "admin_ssh" {
  name        = "admin-ssh"
  description = "Admins can SSH into all server peers"
  enabled     = true

  rule {
    name          = "ssh-netbird"
    action        = "accept"
    bidirectional = false
    enabled       = true
    protocol      = "netbird-ssh"
    sources = [data.netbird_group.users_admin.id]
    destinations = [
      netbird_group.srv_onprem_noida.id,
      netbird_group.srv_oci_bom.id,
      netbird_group.srv_oci_zrh.id,
    ]
  }
}

# # Default policy lookup (to disable after import)

# data "netbird_policy" "default" {
#   name = "Default"
# }

# data "netbird_group" "all" {
#   name = "All"
# }
# resource "netbird_policy" "default" {
#   name        = "Default"
#   description = "This is a default rule that allows connections between all the resources"
#   enabled     = false

#   rule {
#     name          = "Default"
#     action        = "accept"
#     bidirectional = true
#     enabled       = false
#     protocol      = "all"
#     sources       = [data.netbird_group.all.id]
#     destinations  = [data.netbird_group.all.id]
#   }
# }

# Jellyfin Users
# # Only access to jellyfin service on on-prem
# resource "netbird_policy" "jellyfin_access" {
#   name        = "jellyfin-user-access"
#   description = "Jellyfin users can only access Jellyfin service"
#   enabled     = true

#   rule {
#     name          = "jellyfin-tcp"
#     action        = "accept"
#     bidirectional = false
#     enabled       = true
#     protocol      = "tcp"
#     sources       = [data.netbird_group.users_jellyfin.id]
#     destinations  = [netbird_group.srv_onprem_noida.id]
#     ports = ["8096", "8920"]
#   }
# }

# # Immich Users
# resource "netbird_policy" "immich_access" {
#   name        = "immich-user-access"
#   description = "Immich users can only access Immich service"
#   enabled     = true

#   rule {
#     name          = "immich-tcp"
#     action        = "accept"
#     bidirectional = false
#     enabled       = true
#     protocol      = "tcp"
#     sources       = [data.netbird_group.users_immich.id]
#     destinations  = [netbird_group.srv_onprem_noida.id]
#     ports = ["2283"]
#   }
# }

# resource "netbird_policy" "ai_access" {
#   name    = "ai-user-access"
#   enabled = true
#   rule {
#     name          = "ai-tcp"
#     action        = "accept"
#     bidirectional = false
#     enabled       = true
#     protocol      = "tcp"
#     sources       = [data.netbird_group.users_ai.id]
#     destinations  = [netbird_group.srv_onprem_noida.id]
#     ports         = ["3033"]
#   }
# }

resource "netbird_policy" "jellyfin_access" {
  name    = "jellyfin-access"
  enabled = true
  rule {
    name          = "jellyfin-tcp"
    action        = "accept"
    bidirectional = false
    protocol      = "tcp"
    ports         = ["8096"]
    sources       = [data.netbird_group.users_jellyfin.id]
    destinations  = [netbird_group.srv_onprem_mdsrv.id]
  }
}

resource "netbird_policy" "immich_access" {
  name    = "immich-access"
  enabled = true
  rule {
    name          = "immich-tcp"
    action        = "accept"
    bidirectional = false
    protocol      = "tcp"
    ports         = ["2283"]
    sources       = [data.netbird_group.users_immich.id]
    destinations  = [netbird_group.srv_onprem_mdsrv.id]
  }
}

resource "netbird_policy" "ai_access" {
  name    = "ai-access"
  enabled = true
  rule {
    name          = "ai-tcp"
    action        = "accept"
    bidirectional = false
    protocol      = "tcp"
    ports         = ["3033"]
    sources       = [data.netbird_group.users_ai.id]
    destinations  = [netbird_group.srv_onprem_mdsrv.id]
  }
}
