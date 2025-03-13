module "apisix" {
  timeout = 240

  source = "./modules/apisix"

  values = [
    file("${path.module}/config/gateway/values.yaml")
  ]
}