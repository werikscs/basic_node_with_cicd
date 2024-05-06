data "oci_identity_availability_domains" "ads" {
  compartment_id = var.COMPUTE_COMPARTMENT_ID
}