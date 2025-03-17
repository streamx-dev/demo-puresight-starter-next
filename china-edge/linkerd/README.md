# StreamX multi-cluster configuration

## Installing linkerd
- Generate trust anchor using anchor/generate.sh
- Export proper KUBECONFIG
- On each of the clusters execute (from the us/china directories):
    ```shell
    # first, install the Linkerd CRDs
    linkerd install --crds | kubectl apply -f -
    
    # install the Linkerd control plane, with the certificates we just generated.
    linkerd install \
      --identity-trust-anchors-file ../linkerd/anchor/ca.crt \
      --identity-issuer-certificate-file ../linkerd/anchor/issuer.crt \
      --identity-issuer-key-file ../linkerd/anchor/issuer.key \
      | kubectl apply -f -
    ```

For more details see: https://linkerd.io/2.16/tasks/generate-certificates/#trust-anchor-certificate

## Install multicluster extension

On US cluster run:
```shell
linkerd multicluster install | \
    kubectl apply -f -
```

On China cluster run:
```shell
    linkerd multicluster install | \
     sed 's|gcr.io/google_containers/pause:3.2|registry.aliyuncs.com/google_containers/pause:3.2|g' | \
     kubectl apply -f -
```


If nodes cannot start, because of problems with iptables access, run:

```shell
linkerd install-cni | kubectl apply -f -
linkerd upgrade --linkerd-cni-enabled | kubectl apply -f -
```

Run check and verify that multicluster module is enabled and healthy:
```shell
linkerd check 
```

NOTE: t may be required to reinstall multi-cluster

## Linking

- Got to project root directory.
- Export common KUBECONFIG:
```shell
export KUBECONFIG=china-edge/china/terraform/.env/kubeconfig:china-edge/us/terraform/.env/kubeconfig
```
- Rename the contexts to match: china/us
    NOTE: you need to manually merge kubeconfig files if both are exported from Alibaba!
    Test if `--cluster` switch works properly

Link the clusters:

```shell
linkerd --context=us multicluster link --cluster-name us |
  kubectl --context=china apply -f -
```

Verify:
```shell
linkerd --context=china multicluster check
linkerd --context=china multicluster gateways
```

Expose Pulsar Broker:
```shell
kubectl label svc pulsar-broker mirror.linkerd.io/exported=true -n kaap --context=us
```
Add proxies to the default namespace:
```shell
kubectl label namespace mesh linkerd.io/inject-enabled --context=china


```

More info can be found here: https://linkerd.io/2.16/tasks/installing-multicluster/


NOTES:
```shell
The label selector also controls the mode a service is exported in. For example, by default, services labeled with mirror.linkerd.io/exported=true will be exported in hierarchical (gateway) mode, whereas services labeled with mirror.linkerd.io/exported=remote-discovery will be exported in flat (pod-to-pod) mode. Since the configuration is service-centric, switching from gateway to pod-to-pod mode is trivial and does not require the extension to be re-installed.
```