# On-Prem Noida setup key
resource "netbird_setup_key" "onprem_noida" {
  name                   = "srv-onprem-noida-key"
  type                   = "reusable"
  expiry_seconds         = 0
  usage_limit            = 0
  ephemeral              = false
  allow_extra_dns_labels = true
  auto_groups = [
    netbird_group.srv_onprem_noida.id,
  ]
}

# OCI Mumbai setup key
resource "netbird_setup_key" "oci_bom" {
  name                   = "srv-oci-bom-key"
  type                   = "reusable"
  expiry_seconds         = 0
  usage_limit            = 0
  ephemeral              = false
  allow_extra_dns_labels = true
  auto_groups = [
    netbird_group.srv_oci_bom.id,
  ]
}

# OCI Zurich setup key
resource "netbird_setup_key" "oci_zrh" {
  name                   = "srv-oci-zrh-key"
  type                   = "reusable"
  expiry_seconds         = 0
  usage_limit            = 0
  ephemeral              = false
  allow_extra_dns_labels = true
  auto_groups = [
    netbird_group.srv_oci_zrh.id,
  ]
}
