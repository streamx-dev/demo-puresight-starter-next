module "apisix" {
  source = "./modules/apisix"

  values = [
    file("${path.module}/config/gateway/values.yaml")
  ]
}

# TODO this is a workaround, we don't need the content of this namespace
resource "kubernetes_namespace" "prometheus_stack" {
  metadata {
    name = "prometheus-stack"
  }
}

module "streamx" {
  source  = "streamx-dev/charts/helm"
  version = "0.0.4"

  cert_manager_lets_encrypt_issuer_acme_email              = var.cert_manager_lets_encrypt_issuer_acme_email
  cert_manager_lets_encrypt_issuer_prod_letsencrypt_server = var.cert_manager_lets_encrypt_issuer_prod_letsencrypt_server
  cert_manager_lets_encrypt_issuer_ingress_class           = "apisix"

  streamx_operator_image_pull_secret_registry_email    = var.streamx_operator_image_pull_secret_registry_email
  streamx_operator_image_pull_secret_registry_password = var.streamx_operator_image_pull_secret_registry_password
  streamx_operator_chart_repository_username           = "_json_key_base64"
  streamx_operator_chart_repository_password           = var.streamx_operator_image_pull_secret_registry_password

  # Disabling cert-manager-lets-encrypt
  cert_manager_lets_encrypt_issuer_enabled    = false
  ingress_controller_nginx_enabled            = false
  loki_create_namespace                       = false
  loki_enabled                                = false
  minio_enabled                               = false
  opentelemetry_collector_deamonset_enabled   = false
  opentelemetry_collector_statefulset_enabled = false
  opentelemetry_operator_enabled              = false
  prometheus_stack_enabled                    = false
  pulsar_kaap_enabled                         = false
  tempo_create_namespace                      = false
  tempo_enabled                               = false

  streamx_operator_values = [
    file("${path.module}/config/streamx-operator/values.yaml")
  ]
}