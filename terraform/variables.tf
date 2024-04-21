variable "BACKEND_HTTP_ADDRESS" {
  description = "http address"
  type = string
}

variable "PROVIDER_TENANCY_OCID" {
  description = "OCI tenancy OCID"
  type        = string
}

variable "PROVIDER_USER_OCID" {
  description = "OCI user OCID"
  type        = string
}

variable "PROVIDER_PRIVATE_KEY_FILE_PATH" {
  description = "OCI private key file path"
}

variable "PROVIDER_FINGERPRINT" {
  description = "OCI user fingerprint"
  type        = string
}

variable "PROVIDER_REGION" {
  description = "OCI compartment OCID"
  type        = string
}

variable "COMPUTE_COMPARTMENT_ID" {
  description = "OCI compartment id"
  type        = string
}

variable "COMPUTE_VM_SHAPE" {
  description = "OCI vm shape"
  type        = string
}

variable "COMPUTE_SOURCE_ID" {
  description = "OCI source id"
  type        = string
}

variable "COMPUTE_SOURCE_TYPE" {
  description = "OCI source type"
  type        = string
}

variable "COMPUTE_DISPLAY_NAME" {
  description = "OCI display name"
  type        = string
}

variable "COMPUTE_SUBNET_ID" {
  description = "OCI subnet id"
  type        = string
}

variable "COMPUTE_INSTANCE" {
  description = "OCI compute instance OCID"
  type        = string
}

variable "COMPUTE_SSH_AUTHORIZED_KEYS_PATH" {
  description = "ssh authorized keys"
  type        = string
}