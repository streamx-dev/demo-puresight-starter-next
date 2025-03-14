variable "streamx_operator_image_pull_secret_registry_email" {
  description = "StreamX Operator container image registry user email."
  type        = string
}

variable "streamx_operator_image_pull_secret_registry_password" {
  description = "StreamX Operator container image registry user password."
  type        = string
  sensitive   = true
}

variable "cert_manager_lets_encrypt_issuer_acme_email" {
  description = "Email passed to acme server."
  type        = string
}

variable "cert_manager_lets_encrypt_issuer_prod_letsencrypt_server" {
  description = "Determines if created Cluster Issuer should use prod or staging acme server."
  type        = bool
  default     = false
}