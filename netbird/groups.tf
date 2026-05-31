# Server Groups
# Pattern: srv-deploymentType-region

resource "netbird_group" "srv_onprem_noida" {
  name = "srv-onprem-noida"
}

resource "netbird_group" "srv_onprem_mdsrv" {
  name = "srv-onprem-mdsrv"
}

resource "netbird_group" "srv_oci_bom" {
  name = "srv-oci-bom"
}

resource "netbird_group" "srv_oci_zrh" {
  name = "srv-oci-zrh"
}

# User Groups (auto-mapped from IdP JWT)
# a caveat with these: groups need to be created by netbird i.e, must not exist beforehand
# afai researched about it using chatbots, netbird tags groups with either api or netbird
# jwt sync only syncs groups with netbird tag

data "netbird_group" "users_admin" {
  name = "users-admin"
}

data "netbird_group" "users_jellyfin" {
  name = "users-jellyfin"
}

data "netbird_group" "users_immich" {
  name = "users-immich"
}

data "netbird_group" "users_ai" {
  name = "users-ai"
}
