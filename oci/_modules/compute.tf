locals {
  amd1_instance_name = "${var.region_name}-amd-1"
  amd2_instance_name = "${var.region_name}-amd-2"
  arm_instance_name  = "${var.region_name}-arm"
}

resource "oci_core_instance" "amd1_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = local.amd1_instance_name
  shape               = "VM.Standard.E2.1.Micro"
  fault_domain        = "FAULT-DOMAIN-1"
  state               = "RUNNING"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
    vcpus         = 2
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.main.id
    display_name           = "${local.amd1_instance_name}-vnic"
    assign_public_ip       = false
    skip_source_dest_check = true
    hostname_label         = local.amd1_instance_name
    private_ip             = var.amd1_private_ip
    nsg_ids                = [oci_core_network_security_group.amd1_nsg.id]
  }

  source_details {
    source_type             = "image"
    source_id               = var.amd_image_ocid
    boot_volume_vpus_per_gb = 10
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    firmware         = "UEFI_64"
    network_type     = "PARAVIRTUALIZED"
    # is_pv_encryption_in_transit_enabled = false
  }

  availability_config {
    recovery_action             = "RESTORE_INSTANCE"
    is_live_migration_preferred = true
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      name          = "Compute Instance Monitoring"
      desired_state = "ENABLED"
    }

    plugins_config {
      name          = "Custom Logs Monitoring"
      desired_state = "ENABLED"
    }
  }

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }

}

resource "oci_core_instance" "amd2_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = local.amd2_instance_name
  shape               = "VM.Standard.E2.1.Micro"
  fault_domain        = "FAULT-DOMAIN-2"
  state               = "RUNNING"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
    vcpus         = 2
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.main.id
    display_name           = "${local.amd2_instance_name}-vnic"
    assign_public_ip       = true
    skip_source_dest_check = true
    hostname_label         = local.amd2_instance_name
    private_ip             = var.amd2_private_ip
    nsg_ids                = [oci_core_network_security_group.amd2_nsg.id]
  }

  source_details {
    source_type             = "image"
    source_id               = var.amd_image_ocid
    boot_volume_vpus_per_gb = 10
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    firmware         = "UEFI_64"
    network_type     = "PARAVIRTUALIZED"
    # is_pv_encryption_in_transit_enabled = false
  }

  availability_config {
    recovery_action             = "RESTORE_INSTANCE"
    is_live_migration_preferred = true
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      name          = "Compute Instance Monitoring"
      desired_state = "ENABLED"
    }

    plugins_config {
      name          = "Custom Logs Monitoring"
      desired_state = "ENABLED"
    }
  }

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }

}

resource "oci_core_instance" "arm_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = local.arm_instance_name
  shape               = "VM.Standard.A1.Flex"
  fault_domain        = "FAULT-DOMAIN-3"
  state               = "RUNNING"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
    vcpus         = 2
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.main.id
    display_name           = "${local.arm_instance_name}-vnic"
    assign_public_ip       = false
    skip_source_dest_check = true
    hostname_label         = local.arm_instance_name
    private_ip             = var.arm_private_ip
    nsg_ids                = [oci_core_network_security_group.arm_nsg.id]
  }

  source_details {
    source_type             = "image"
    source_id               = var.arm_image_ocid
    boot_volume_vpus_per_gb = 10
    boot_volume_size_in_gbs = 100
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    firmware         = "UEFI_64"
    network_type     = "PARAVIRTUALIZED"
    # is_pv_encryption_in_transit_enabled = false
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      name          = "Compute Instance Monitoring"
      desired_state = "ENABLED"
    }

    plugins_config {
      name          = "Custom Logs Monitoring"
      desired_state = "ENABLED"
    }
  }

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }

}
