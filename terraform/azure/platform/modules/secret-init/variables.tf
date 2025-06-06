variable "create_namespace" {
  description = "Namespace will be created if set to true"
  default     = false
  type        = bool
}

variable "namespace" {
  description = "Namespace of the secret"
  type        = string
}

variable "secret_name" {
  description = "Secret name"
  type        = string
}

variable "secret_file" {
  description = "Yaml file with secret content"
  default     = null
  type        = string
}