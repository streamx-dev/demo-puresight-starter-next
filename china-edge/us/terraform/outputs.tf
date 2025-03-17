output "loadbalancer_ip" {
  description = "K8s cluster Load Balancer IP"
  value       = module.apisix.ingress_ip
}
