# Installing Istio based multi cluster

The guide will present how to se tup Istio on two clusters:

- Alibaba - configured in context as alibaba
- Azure - configured in context as azure

Alibaba and Azure will be used as a primary clusters, using
primary-primary setup: https://istio.io/latest/docs/setup/install/multicluster/multi-primary/

## Prerequisites:

### Define CLUSTER environmental variables:

export CTX_CLUSTER1=<your cluster1 context>
export CTX_CLUSTER2=<your cluster2 context>

For example:

```shell
export CTX_CLUSTER1=alibaba
export CTX_CLUSTER2=azure
```

Note that you can combine multiple KUBECONFIG files using example:

```shell
export KUBECONFIG=china-edge/terraform/.env/azure-kubeconfig:china-edge/terraform/.env/kubeconfig
```

### Generate certificates:

Download the script:

```shell
mkdir -p china-edge/istio-mm/certs/
pushd china-edge/istio-mm/certs/
curl https://raw.githubusercontent.com/istio/istio/refs/heads/master/tools/certs/Makefile.selfsigned.mk > Makefile.selfsigned.mk
curl https://raw.githubusercontent.com/istio/istio/refs/heads/master/tools/certs/common.mk > common.mk
popd
```

Execute make to generate root-ca and to cluster certificates:

```shell
pushd china-edge/istio-mm/certs/
make -f Makefile.selfsigned.mk root-ca
make -f Makefile.selfsigned.mk cluster1-cacerts
make -f Makefile.selfsigned.mk cluster2-cacerts
popd
```

Upload certificates to clusters:

```shell
kubectl --context="${CTX_CLUSTER1}" create namespace istio-system
kubectl --context="${CTX_CLUSTER1}" create secret generic cacerts -n istio-system \
      --from-file=china-edge/istio-mm/certs/cluster1/ca-cert.pem \
      --from-file=china-edge/istio-mm/certs/cluster1/ca-key.pem \
      --from-file=china-edge/istio-mm/certs/cluster1/root-cert.pem \
      --from-file=china-edge/istio-mm/certs/cluster1/cert-chain.pem
```

```shell
kubectl --context="${CTX_CLUSTER2}" create namespace istio-system
kubectl --context="${CTX_CLUSTER2}" create secret generic cacerts -n istio-system \
      --from-file=china-edge/istio-mm/certs/cluster2/ca-cert.pem \
      --from-file=china-edge/istio-mm/certs/cluster2/ca-key.pem \
      --from-file=china-edge/istio-mm/certs/cluster2/root-cert.pem \
      --from-file=china-edge/istio-mm/certs/cluster2/cert-chain.pem

```

### Install Istioctl

Download the latest release with the command:

```shell
curl -sL https://istio.io/downloadIstioctl | sh -
```

Add the `istioctl` client to your path, for example .zprofile:

```shell
export PATH=$HOME/.istioctl/bin:$PATH
```

## Installing clusters as primaries:

```shell
istioctl install --context="${CTX_CLUSTER1}" -f china-edge/istio-mm/alibaba-cluster.yaml
```
```shell
istioctl install --context="${CTX_CLUSTER2}" -f china-edge/istio-mm/azure-cluster.yaml
```

## Link clusters

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER1}" \
    --name=alibaba | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"
```

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER2}" \
    --name=azure | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"
```


## Enable proxy

Enable ingestion on kaap namespace in Azure:
```shell
# kubectl label --context="${CTX_CLUSTER2}" namespace kaap istio-injection=enabled
```

Run Analyze:

```shell
istioctl analyze --all-namespaces  
```



## Cleanup

```shell

istioctl uninstall --context="${CTX_CLUSTER1}" -y --purge
kubectl delete ns istio-system --context="${CTX_CLUSTER1}"

istioctl uninstall --context="${CTX_CLUSTER2}" -y --purge
kubectl delete ns istio-system --context="${CTX_CLUSTER2}"
```


===========================================

## Alternative: Setup multi-primary, multi-network
https://istio.io/latest/docs/setup/install/multicluster/multi-primary_multi-network/

Set default namespace with network for Alibaba:

```shell
kubectl --context="${CTX_CLUSTER1}" create namespace istio-system && \
kubectl --context="${CTX_CLUSTER1}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
```

Create images pull secrets using script.

Install Alibaba as primary:

```shell
istioctl install --context="${CTX_CLUSTER1}" -f china-edge/istio-mm/alibaba-cluster.yaml
```

Install gateway:

```shell
sh china-edge/istio-mm/gen-eastwest-gateway.sh \
    --network network1 | \
    istioctl --context="${CTX_CLUSTER1}" install -y -f -
```

Wait for the service to get external IP:

```shell
kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system
```

Expose services in Alibaba:

```shell
kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
    china-edge/istio-mm/expose-services.yaml
```

Set default network for Azure:

```shell
kubectl --context="${CTX_CLUSTER2}" create namespace istio-system && \
kubectl --context="${CTX_CLUSTER2}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER2}" label namespace istio-system topology.istio.io/network=network2
```

Install Azure as primary:

```shell
istioctl install --context="${CTX_CLUSTER2}" -f china-edge/istio-mm/azure-cluster-n2.yaml
```

Install gateway:

```shell
sh china-edge/istio-mm/gen-eastwest-gateway.sh \
    --network network2 | \
    istioctl --context="${CTX_CLUSTER2}" install -y -f -
```

Wait for the service to get external IP:
```shell
kubectl --context="${CTX_CLUSTER2}" get svc istio-eastwestgateway -n istio-system
```

Expose services in Azure:

```shell
kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f \
    china-edge/istio-mm/expose-services.yaml
```

Enable services discovery:

```shell
istioctl create-remote-secret \
  --context="${CTX_CLUSTER1}" \
  --name=alibaba | \
  kubectl apply -f - --context="${CTX_CLUSTER2}"
```

```shell
istioctl create-remote-secret \
  --context="${CTX_CLUSTER2}" \
  --name=azure | \
  kubectl apply -f - --context="${CTX_CLUSTER1}"
```