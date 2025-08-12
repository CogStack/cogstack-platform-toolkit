# Getting Started

This page outlines the basic setup and requirements for running CogStack

See the Quickstart guide for a tutorial that will install a local kubernetes using Minikube, and run an instance of CogStack using Helm.

## Models
The primary thing you will need to arrange is a trained model to be used for the natural language processing functionality of CogStack. We provide small free models, though to get access to better performing models please contact us

## Technologies and Tools

These technologies and tools can be used to deploy CogStack. Not all are required depending on the method of deployment you want to use.

Our recommended deployment method is on Kubernetes by using Helm charts

- [GitOps](https://www.redhat.com/en/topics/devops/what-is-gitops)
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads)
- [Kubernetes](https://kubernetes.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)
- [Portainer](https://www.portainer.io/)

See the official documentation on these tools for the best documentation for installation and setup. 

## Cloud Accounts & Permissions

If you plan to deploy on cloud providers like AWS, Azure, or OpenStack, ensure you have the appropriate accounts set up with necessary permissions. Refer to the respective provider’s documentation for guidance.


## Contents
```{toctree}
:maxdepth: 2

quickstart
```
