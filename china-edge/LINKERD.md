# Installing Linkerd based multi cluster

The guide will present how to se tup Linkerd on two clusters:

- Alibaba - configured in context as alibaba
- Azure   - configured in context as azure

## Prerequisites:

- Install Linkerd on your host machine:

```shell
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
```

- Add Linkerd to your .zprofile:

```shell
export PATH=$HOME/.linkerd2/bin:$PATH
```

- Have installed: `yq` and `step` (both can be installed using brew)

- Note that you can combine multiple KUBECONFIG files using example:

```shell
export KUBECONFIG=china-edge/terraform/.env/azure-kubeconfig:china-edge/terraform/.env/kubeconfig
```

## Generate anchor certificates:

Source: https://linkerd.io/2-edge/tasks/generate-certificates/

```shell
cd china-edge/anchor

step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure

step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 8760h --no-password --insecure \
--ca ca.crt --ca-key ca.key

```

## Install Linkerd on both clusters

1. Check preconditions:
    ```shell
    linkerd --context=azure check --pre
    linkerd --context=alibaba check --pre
    ```
2. Execute installation
    ```shell
    kubectl config use-context azure
    linkerd install --crds | kubectl apply -f -
    linkerd install \
      --identity-trust-anchors-file ./china-edge/anchor/ca.crt \
      --identity-issuer-certificate-file ./china-edge/anchor/issuer.crt \
      --identity-issuer-key-file ./china-edge/anchor/issuer.key \
      | kubectl apply -f -
    
   kubectl config use-context alibaba
    linkerd install --crds | kubectl apply -f -
    linkerd install --set "proxyInit.iptablesMode=nft" \
      --identity-trust-anchors-file ./china-edge/anchor/ca.crt \
      --identity-issuer-certificate-file ./china-edge/anchor/issuer.crt \
      --identity-issuer-key-file ./china-edge/anchor/issuer.key \
      | kubectl apply -f -
    ```
3. Verify the results
    ```shell
    linkerd --context=azure check
    linkerd --context=alibaba check
    ```
   
## Install multi-cluster extension:

1. Execute on Azure
    ```shell
    kubectl config use-context azure
    linkerd multicluster install | \
    kubectl apply -f -
    ```
2. Execute for Alibaba (you need to replace one container registry).
    ```shell
    kubectl config use-context alibaba
    linkerd multicluster install | \
     sed 's|gcr.io/google_containers/pause:3.2|registry.aliyuncs.com/google_containers/pause:3.2|g' | \
     kubectl apply -f -
    ```
3. Verify the results
    ```shell
    linkerd multicluster --context=azure check
    linkerd multicluster --context=alibaba check
    ```
   
## Link two clusters. 

Use Alibaba as source na Azure as a target and link them using the command:
```shell
linkerd --context=azure multicluster link --cluster-name azure |
  kubectl --context=alibaba apply -f -
```

Create Namespace in Alibaba

```shell
kubectl --context=alibaba create namespace kaap
```

and export Pulsar Broker service on Azure cluster:

```shell
kubectl --context=azure label svc pulsar-broker mirror.linkerd.io/exported=true -n kaap
```

Verify that the service exists on Alibaba:

```shell
kubectl --context=alibaba get svc -n kaap
```