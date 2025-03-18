# Installing Istio based multi cluster

The guide will present how to se tup Istio on two clusters:

- china - configured in context as alibaba in China
- us - configured in context as alibaba US

Alibaba and Azure will be used as a primary clusters, using
primary-primary setup: https://istio.io/latest/docs/setup/install/multicluster/multi-primary/

## Prerequisites:

### Define CLUSTER environmental variables:

export CTX_CLUSTER1=<your cluster1 context>
export CTX_CLUSTER2=<your cluster2 context>

For example:

```shell
export CTX_CLUSTER1=china
export CTX_CLUSTER2=us
```

Note that you can combine multiple KUBECONFIG files using example:

```shell
export KUBECONFIG=china-edge/us/terraform/.env/kubeconfig:china-edge/china/terraform/.env/kubeconfig
```

### Generate certificates:

Download the script:

```shell
mkdir -p china-edge/istio/certs/
pushd china-edge/istio-mm/certs/
curl https://raw.githubusercontent.com/istio/istio/refs/heads/master/tools/certs/Makefile.selfsigned.mk > Makefile.selfsigned.mk
curl https://raw.githubusercontent.com/istio/istio/refs/heads/master/tools/certs/common.mk > common.mk
popd
```

Execute make to generate root-ca and to cluster certificates:

```shell
pushd china-edge/istio/certs/
make -f Makefile.selfsigned.mk root-ca
make -f Makefile.selfsigned.mk cluster1-cacerts
make -f Makefile.selfsigned.mk cluster2-cacerts
popd
```

Upload certificates to clusters:

```shell
kubectl --context="${CTX_CLUSTER1}" create namespace istio-system
kubectl --context="${CTX_CLUSTER1}" create secret generic cacerts -n istio-system \
      --from-file=china-edge/istio/certs/cluster1/ca-cert.pem \
      --from-file=china-edge/istio/certs/cluster1/ca-key.pem \
      --from-file=china-edge/istio/certs/cluster1/root-cert.pem \
      --from-file=china-edge/istio/certs/cluster1/cert-chain.pem
```

```shell
kubectl --context="${CTX_CLUSTER2}" create namespace istio-system
kubectl --context="${CTX_CLUSTER2}" create secret generic cacerts -n istio-system \
      --from-file=china-edge/istio/certs/cluster2/ca-cert.pem \
      --from-file=china-edge/istio/certs/cluster2/ca-key.pem \
      --from-file=china-edge/istio/certs/cluster2/root-cert.pem \
      --from-file=china-edge/istio/certs/cluster2/cert-chain.pem

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
istioctl install --context="${CTX_CLUSTER1}" -f china-edge/istio/china-cluster.yaml
```
```shell
istioctl install --context="${CTX_CLUSTER2}" -f china-edge/istio/us-cluster.yaml
```

## Link clusters

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER1}" \
    --name=china | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"
```

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER2}" \
    --name=us | \
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


Alternative using Helm:

```shell
helm install istio-base istio/base -n istio-system --kube-context "${CTX_CLUSTER1}"
```

```shell
helm install istiod istio/istiod -n istio-system --kube-context "${CTX_CLUSTER1}" --set global.meshID=mesh1 --set global.multiCluster.clusterName=cluster1 --set global.network=network1 --set global.hub=crpi-ynub1f3ynqwgpy46.cn-hangzhou.personal.cr.aliyuncs.com/streamx-demo --set "global.imagePullSecrets[0]=streamx-demo-pull-secret"

```

```shell
helm install istio-base istio/base -n istio-system --kube-context "${CTX_CLUSTER2}"
```

```shell
helm install istiod istio/istiod -n istio-system --kube-context "${CTX_CLUSTER2}" --set global.meshID=mesh1 --set global.multiCluster.clusterName=cluster2 --set global.network=network1

```

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER1}" \
    --name=cluster1 | \
    kubectl apply -f - --context="${CTX_CLUSTER2}"

```

```shell
 istioctl create-remote-secret \
    --context="${CTX_CLUSTER2}" \
    --name=cluster2 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"
secret/istio-remote-secret-cluster2 created

```