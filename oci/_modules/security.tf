locals {
  amd1_nsg_name = "${var.region_name}-amd-1-nsg"
  amd2_nsg_name = "${var.region_name}-amd-2-nsg"
  arm_nsg_name  = "${var.region_name}-arm-nsg"
}

# AMD-1 NSG
resource "oci_core_network_security_group" "amd1_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.amd1_nsg_name

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }
}

# AMD-2 NSG
resource "oci_core_network_security_group" "amd2_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.amd2_nsg_name

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }
}

# ARM NSG
resource "oci_core_network_security_group" "arm_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = local.arm_nsg_name

  defined_tags = {
    "Oracle-Tags.CreatedBy" = "terraform"
    "Oracle-Tags.CreatedOn" = timestamp()
  }
}

# AMD-1 NSG Rules
resource "oci_core_network_security_group_security_rule" "amd1_egress" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Egress allowed to everywhere"
}

resource "oci_core_network_security_group_security_rule" "amd1_internal" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"
  description               = "For all comms with other servers in this subnet"
}

resource "oci_core_network_security_group_security_rule" "amd1_icmp" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Ping allowed for all"
}

resource "oci_core_network_security_group_security_rule" "amd1_ssh" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "SSH allowed from all networks"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "amd1_http" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "amd1_https" {
  network_security_group_id = oci_core_network_security_group.amd1_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# AMD-2 NSG Rules
resource "oci_core_network_security_group_security_rule" "amd2_egress" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Egress allowed to everywhere"
}

resource "oci_core_network_security_group_security_rule" "amd2_internal" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"
  description               = "For all comms with other servers in this subnet"
}

resource "oci_core_network_security_group_security_rule" "amd2_icmp" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Ping allowed for all"
}

resource "oci_core_network_security_group_security_rule" "amd2_ssh" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "SSH allowed from all networks"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "amd2_http" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "amd2_https" {
  network_security_group_id = oci_core_network_security_group.amd2_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_egress" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Egress allowed to everywhere"
}

resource "oci_core_network_security_group_security_rule" "arm_internal" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"
  description               = "For all comms with other servers in this subnet"
}

resource "oci_core_network_security_group_security_rule" "arm_icmp" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Ping allowed from all networks"
}

resource "oci_core_network_security_group_security_rule" "arm_ssh" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "SSH allowed from all networks"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_http" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Traefik http"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_https" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Traefik https"

  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_netbird" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "For Netbird"

  udp_options {
    destination_port_range {
      min = 51820
      max = 51820
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_wireguard" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "For Wireguard"

  udp_options {
    destination_port_range {
      min = 51822
      max = 51822
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_headscale" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "For headscale direct connection"

  udp_options {
    destination_port_range {
      min = 41641
      max = 41641
    }
  }
}

resource "oci_core_network_security_group_security_rule" "arm_stun" {
  network_security_group_id = oci_core_network_security_group.arm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "STUN/TURN for media"

  udp_options {
    destination_port_range {
      min = 3478
      max = 3478
    }
  }
}
