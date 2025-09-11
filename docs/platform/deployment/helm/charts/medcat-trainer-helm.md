# MedCAT Trainer Helm Chart

This Helm chart deploys MedCAT Trainer and infrastructure to a Kubernetes cluster.

By default the chart will:

- Run MedCAT Trainer Django server
- Run NGINX for static site hosting and routing
- Run a SOLR and Zookeeper cluster for the Concept DB
- Run a Postgres database for persistence


## Installation

```sh
helm install my-medcat-trainer oci://registry-1.docker.io/cogstacksystems/medcat-trainer-helm
```

## Configuration

See these values for common configurations to change:

| Setting  |description    |
| -------- | -------- |
| `env`          | Environment variables as defined in the [MedCAT Trainer docs](https://docs.cogstack.org/projects/medcat-trainer/en/latest/installation.html).    |
|`medcatConfig`|MedCAT config file as described [here](https://github.com/CogStack/cogstack-nlp/blob/main/medcat-v2/medcat/config/config.py)|
| `env.CSRF_TRUSTED_ORIGINS` | The Host and Port to access the application on |


### Use Sqlite instead of Postgres

Sqlite can be used for smaller single instance deployments

Set these values:

```yaml
DB_ENGINE: "sqlite3"

postgresql:
  enabled: false
```

## Missing features
These features are not yet existing but to be added in future:
- Use a pre existing postgres db
- Use a pre existing SOLR instance
- Migrate from supervisord to standalone deployment for background tasks for better scaling
- Support SOLR authentication from medcat trainer
- Support passing DB OPTIONS to medcat trainer for use in cloud environments
