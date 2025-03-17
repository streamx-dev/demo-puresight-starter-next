## Deploying a mesh

Upload the certificate :

## Configuring Kubernetes Config

To use Kubernetes Configuration in your shell, use the following command:

```bash
export KUBECONFIG=terraform/.env/kubeconfig
```


```shell
kubectl apply -f mesh/tls/china-blueprint-web.crt
```


With KUBECONFIG configured, you can invoke:

```shell
streamx deploy -f mesh/mesh.yaml
```
