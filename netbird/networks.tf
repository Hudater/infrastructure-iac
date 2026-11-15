# On-Prem Network
resource "netbird_network" "onprem" {
  name        = "onprem"
  description = "On-premises network PVE + k3s cluster"
}

resource "netbird_network_resource" "onprem_vlan200" {
  network_id  = netbird_network.onprem.id
  name        = "onprem-vlan200"
  description = "On-prem VLAN 200"
  address     = "10.2.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_onprem_noida.id]
}

resource "netbird_network_resource" "onprem_vlan500" {
  network_id  = netbird_network.onprem.id
  name        = "onprem-vlan500"
  description = "On-prem VLAN 500"
  address     = "10.5.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_onprem_noida.id]
}

resource "netbird_network_resource" "onprem_vlan999" {
  network_id  = netbird_network.onprem.id
  name        = "onprem-vlan999"
  description = "On-prem VLAN 999 / test cluster"
  address     = "10.9.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_onprem_noida.id]
}

resource "netbird_network_router" "onprem" {
  network_id  = netbird_network.onprem.id
  peer_groups = [netbird_group.srv_onprem_noida.id]
  metric      = 100
  masquerade  = true
  enabled     = true
}

# OCI Mumbai Network
resource "netbird_network" "oci_bom" {
  name        = "oci-bom"
  description = "OCI Mumbai ARM prod ingress + x86 micros"
}

resource "netbird_network_resource" "oci_bom_subnet1" {
  network_id  = netbird_network.oci_bom.id
  name        = "oci-bom-subnet-60"
  description = "OCI Mumbai subnet 10.60.0.0/24"
  address     = "10.60.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_oci_bom.id]
}

resource "netbird_network_router" "oci_bom" {
  network_id  = netbird_network.oci_bom.id
  peer_groups = [netbird_group.srv_oci_bom.id]
  metric      = 100
  masquerade  = true
  enabled     = true
}

# OCI Mumbai lxd bridge (10.70.0.0/24 exists only on bom-arm, so only bom-arm may route it)
resource "netbird_network" "oci_bom_lxd" {
  name        = "oci-bom-lxd"
  description = "lxd bridge on bom-arm"
}

resource "netbird_network_resource" "oci_bom_lxd" {
  network_id  = netbird_network.oci_bom_lxd.id
  name        = "oci-bom-subnet-70"
  description = "bom-arm lxd subnet 10.70.0.0/24"
  address     = "10.70.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_oci_bom_arm.id]
}

resource "netbird_network_router" "oci_bom_lxd" {
  network_id  = netbird_network.oci_bom_lxd.id
  peer_groups = [netbird_group.srv_oci_bom_arm.id]
  metric      = 100
  masquerade  = true
  enabled     = true
}

# OCI Zurich Network
resource "netbird_network" "oci_zrh" {
  name        = "oci-zrh"
  description = "OCI Zurich 3 servers"
}

resource "netbird_network_resource" "oci_zrh_subnet1" {
  network_id  = netbird_network.oci_zrh.id
  name        = "oci-zrh-subnet-80"
  description = "OCI Zurich subnet 10.80.0.0/24"
  address     = "10.80.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_oci_zrh.id]
}

resource "netbird_network_router" "oci_zrh" {
  network_id  = netbird_network.oci_zrh.id
  peer_groups = [netbird_group.srv_oci_zrh.id]
  metric      = 100
  masquerade  = true
  enabled     = true
}

# OCI Zurich lxd bridge (10.90.0.0/24 exists only on zrh-arm, so only zrh-arm may route it)
resource "netbird_network" "oci_zrh_lxd" {
  name        = "oci-zrh-lxd"
  description = "lxd bridge on zrh-arm"
}

resource "netbird_network_resource" "oci_zrh_lxd" {
  network_id  = netbird_network.oci_zrh_lxd.id
  name        = "oci-zrh-subnet-90"
  description = "zrh-arm lxd subnet 10.90.0.0/24"
  address     = "10.90.0.0/24"
  enabled     = true
  groups      = [netbird_group.srv_oci_zrh_arm.id]
}

resource "netbird_network_router" "oci_zrh_lxd" {
  network_id  = netbird_network.oci_zrh_lxd.id
  peer_groups = [netbird_group.srv_oci_zrh_arm.id]
  metric      = 100
  masquerade  = true
  enabled     = true
}

# exit node

locals {
  all_user_groups = [
    data.netbird_group.users_admin.id,
    data.netbird_group.users_jellyfin.id,
    data.netbird_group.users_immich.id,
    data.netbird_group.users_ai.id,
  ]
}

resource "netbird_route" "exit_oci_bom" {
  network_id  = "exit-oci-bom"
  description = "Exit node via OCI Mumbai"
  network     = "0.0.0.0/0"
  enabled     = true
  masquerade  = true
  metric      = 100
  peer_groups = [netbird_group.srv_oci_bom.id]
  groups      = local.all_user_groups
}

resource "netbird_route" "exit_oci_zrh" {
  network_id  = "exit-oci-zrh"
  description = "Exit node via OCI Zurich"
  network     = "0.0.0.0/0"
  enabled     = true
  masquerade  = true
  metric      = 100
  peer_groups = [netbird_group.srv_oci_zrh.id]
  groups      = local.all_user_groups
}
