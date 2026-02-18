# Tutorial
This page is a tutorial for using helm to deploy CogStack.

We will use the CLI to interact with the cluster, then use Terraform to declaratively install our helm chart.

## Prerequisites
- A kubernetes cluster
- Helm CLI
- Terraform CLI

## Helm Terraform Provider
Terraform is the recommended way to declaritively run CogStack using helm.

```hcl
resource "helm_release" "medcat-service" {
  name         = "medcat-service-terraform"
  chart        = "oci://registry-1.docker.io/cogstacksystems/medcat-service-helm"
  timeout      = 600
  atomic       = true
}
```

### CogStack Helm Module 
The above resource is enough to deploy a helm chart using terraform.

An example module has been created to provide further examples of using Terraform to deploy helm. Please see [Cogstack Helm Module](./cogstack-helm-module.md) for more details.

## Values
We can pass values into the helm chart to customize it.


## Helm CLI Install
We can also use the Helm CLI to deploy CogStack.

Whilst this is quick and useful for development, we advise instead to use IaC with terraform for production deployments so you can easily see what was deployed, how and when. 

```
helm install my-medcat oci://registry-1.docker.io/cogstacksystems/medcat-service-helm --wait --timeout 10m0s
```

## Test
Use Helm Test to verify the deployments.

```bash
helm test my-chart
```

