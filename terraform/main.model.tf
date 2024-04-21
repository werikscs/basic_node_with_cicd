terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.38.0"
    }
  }

  backend "http" {
    address       = "<BACKEND_HTTP_ADDRESS>"
    update_method = "PUT"
  }
}

provider "oci" {
  tenancy_ocid     = var.PROVIDER_TENANCY_OCID
  user_ocid        = var.PROVIDER_USER_OCID
  private_key_path = var.PROVIDER_PRIVATE_KEY_FILE_PATH
  fingerprint      = var.PROVIDER_FINGERPRINT
  region           = var.PROVIDER_REGION
}