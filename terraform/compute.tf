resource "oci_core_instance" "ubuntu_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.COMPUTE_COMPARTMENT_ID
  shape               = var.COMPUTE_VM_SHAPE

  source_details {
    source_id   = var.COMPUTE_SOURCE_ID
    source_type = var.COMPUTE_SOURCE_TYPE
  }

  display_name = var.COMPUTE_DISPLAY_NAME

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.COMPUTE_SUBNET_ID
  }

  metadata = {
    ssh_authorized_keys = file(var.COMPUTE_SSH_AUTHORIZED_KEYS_PATH)
  }

  preserve_boot_volume = false
}