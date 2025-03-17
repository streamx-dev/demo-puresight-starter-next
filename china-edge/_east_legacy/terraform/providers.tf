provider "kubernetes" {
  config_path = ".env/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = ".env/kubeconfig"
  }
}

provider "kubectl" {
  load_config_file = true
  config_path      = ".env/kubeconfig"
}