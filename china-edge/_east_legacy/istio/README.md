# Installing Istio based multi cluster

The guide will present how to se tup Istio on two clusters:

- Alibaba - configured in context as alibaba
- Azure - configured in context as azure

Alibaba will be used as a primary cluster, where Azure will be a remote cluster, using
primary-remote setup: https://istio.io/latest/docs/setup/install/multicluster/primary-remote/

## Prerequisites:

### Define CLUSTER environmental variables:

export CTX_CLUSTER1=<your cluster1 context>
export CTX_CLUSTER2=<your cluster2 context>

For example:

```shell
export CTX_CLUSTER1=alibaba
export CTX_CLUSTER2=azure
```

### Install Istioctl

Download the latest release with the command:

```shell
curl -sL https://istio.io/downloadIstioctl | sh -
```

Add the `istioctl` client to your path, for example .zprofile:

```shell
export PATH=$HOME/.linkerd2/bin:$PATH
```

## Configure Alibaba cluster as primary:

Install Istio by applying the configuration:
```shell
 istioctl install --context="${CTX_CLUSTER1}" -f china-edge/istio/alibaba-cluster.yaml
```

Install the Gateway for azure-alibaba traffic:

```shell 
    sh china-edge/istio/gen-eastwest-gateway.sh \
    --network network1 | \
    istioctl --context="${CTX_CLUSTER1}" install -y -f -
```

Verify that the gateway exist with valid Loadbalancer and IP:

```shell
kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system
```

Expose the gateway in Alibaba cluster:

```shell
kubectl apply --context="${CTX_CLUSTER1}" -n istio-system -f \
    china-edge/istio/expose-istiod.yaml
```

Save the address of a gateway:

```shell
export DISCOVERY_ADDRESS=$(kubectl \
    --context="${CTX_CLUSTER1}" \
    -n istio-system get svc istio-eastwestgateway \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

## Configuring Azure as secondary

Set the control plane:
```shell
kubectl --context="${CTX_CLUSTER2}" create namespace istio-system
kubectl --context="${CTX_CLUSTER2}" annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster1
```

Create the configuration, note that it has to contain exported IP address:

```shell
cat <<EOF > china-edge/istio/azure-cluster.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  profile: remote
  values:
    istiodRemote:
      injectionPath: /inject/cluster/cluster2/net/network1
    global:
      remotePilotAddress: ${DISCOVERY_ADDRESS}
EOF
```

Apply the configuration:

```shell
istioctl install --context="${CTX_CLUSTER2}" -f china-edge/istio/azure-cluster.yaml
```

## Connect clusters by creating remote secret

```shell
istioctl create-remote-secret \
    --context="${CTX_CLUSTER2}" \
    --name=cluster2 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"
```

Enable ingestion on kaap namespace in Azure:
```shell
kubectl label --context="${CTX_CLUSTER2}" namespace kaap \
istio-injection=enabled

# kubectl --context="${CTX_CLUSTER2}" annotate namespace kaap networking.istio.io/exportTo="*"
```
