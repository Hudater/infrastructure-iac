output "setup_keys" {
  sensitive = true
  value = {
    srv_onprem_noida = netbird_setup_key.onprem_noida.key
    srv_oci_bom      = netbird_setup_key.oci_bom.key
    srv_oci_bom_arm  = netbird_setup_key.oci_bom_arm.key
    srv_oci_zrh      = netbird_setup_key.oci_zrh.key
    srv_oci_zrh_arm  = netbird_setup_key.oci_zrh_arm.key
  }
}
