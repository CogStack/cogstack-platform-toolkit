# MedCAT Service Helm Chart

This Helm chart deploys the MedCAT service to a Kubernetes cluster.

## Installation

```sh
helm install my-medcat-service oci://registry-1.docker.io/cogstacksystems/medcat-service-helm
```

## Configuration

You should specify a model pack to be used by the service. By default it will use a small bundled model, which can be used for testing

---
### Option 1: Use the demo model pack

There is a model pack already bundled into medcat service, and is the default in this chart.

This pack is only really used for testing, and has just a few concepts built in. 

###  Option 2: Download Model on Startup

Enable MedCAT to download the model from a remote URL on container startup.

Create a values file like `values-model-download.yaml` and update the env vars with: 
```yaml
env:
  ENABLE_MODEL_DOWNLOAD: "true"
  MODEL_NAME: "medmen"
  MODEL_VOCAB_URL: "https://cogstack-medcat-example-models.s3.eu-west-2.amazonaws.com/medcat-example-models/vocab.dat"
  MODEL_CDB_URL: "https://cogstack-medcat-example-models.s3.eu-west-2.amazonaws.com/medcat-example-models/cdb-medmen-v1.dat"
  MODEL_META_URL: "https://cogstack-medcat-example-models.s3.eu-west-2.amazonaws.com/medcat-example-models/mc_status.zip"
  APP_MODEL_CDB_PATH: "/cat/models/medmen/cdb.dat"
```

Use this if you prefer dynamic loading of models at runtime.

### Option 3: Get a model into a k8s volume, and mount it

The service can use a model pack if you want to setup your own download flow. For example, setup an initContainer pattern that downloads to a volume, then mount the volume yourself.

Use this env variable to point to the file:

Create a values file like `values-model-pack.yaml` and update the env vars with: 
```yaml
env:
  # This defines the Model Pack used by the medcat service
  APP_MEDCAT_MODEL_PACK: "/cat/models/examples/example-medcat-v1-model-pack.zip"
```

## Example

```sh
helm install my-medcat ./medcat-chart -f values-model-pack.yaml
```

or

```sh
helm install my-medcat ./medcat-chart -f values-model-download.yaml
```

### DeID Mode

The service can perform DeID of EHRs by swithcing to the following values

```
env:
  APP_MEDCAT_MODEL_PACK: "/cat/models/examples/example-deid-model-pack.zip"
  DEID_MODE: "true"
  DEID_REDACT: "true"
```


## GPU Support

To run MedCAT Service with GPU acceleration, use the GPU-enabled image and set the pod runtime class accordingly.

Note GPU support is only used for deidentification

Create a values file like `values-gpu.yaml` with the following content:

```yaml
image:
  repository: ghcr.io/cogstack/medcat-service-gpu

runtimeClassName: nvidia

resources:
  limits:
      nvidia.com/gpu: 1
env:
  APP_CUDA_DEVICE_COUNT: 1
  APP_TORCH_THREADS: -1
  DEID_MODE: true
```

> To use GPU acceleration, your Kubernetes cluster should be configured with the NVIDIA GPU Operator or the following components:
> - [NVIDIA device plugin for Kubernetes](https://github.com/NVIDIA/k8s-device-plugin)
> - [NVIDIA GPU Feature Discovery](https://github.com/NVIDIA/gpu-feature-discovery)
> - The [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/)

### Test GPU support
You can verify that the MedCAT Service pod has access to the GPU by executing `nvidia-smi` inside the pod.


```sh
kubectl exec -it <POD_NAME> -- nvidia-smi
```

You should see the NVIDIA GPU device listing if the GPU is properly accessible.
