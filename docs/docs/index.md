Welcome to the CogStack Documentation site.

## What is CogStack?
![CogStack Architecture](overview/attachments/architecture.png)

CogStack is a lightweight distributed, fault tolerant database processing architecture and ecosystem, intended to make NLP processing and preprocessing easier in resource constrained environments. It comprises of multiple components, and has been designed to provide configurable data processing pipelines for working with EHR data.

CogStack uses databases and files as primary sources of EHR data, with support for custom data connectors. The platform leverages [Apache NiFi](https://nifi.apache.org/) to provide fully configurable data processing pipelines with the goal of generating annotated JSON standardised schema files that can be readily indexed into [ElasticSearch](https://www.elastic.co/), stored as files or pushed back to a database.


CogStack is a commercial open-source product, with the code available on GitHub: [https://github.com/CogStack/](https://github.com/CogStack/) . For enterprise deployments, full platform setup, and advanced features, please [contact us](https://docs.cogstack.org/en/latest/).

!!! tip

    CogStack is designed as a microservices-based ecosystem. The recommended deployment method is on **Kubernetes using Helm charts**, which provides cloud-native support, scalability, and reliability. Ready-to-use CogStack images are available from the official Docker Hub under the [cogstacksystems](https://hub.docker.com/u/cogstacksystems/) organisation. Docker Compose is still supported for development and smaller deployments, but Kubernetes is recommended for production environments.

## What is CogStack For?

CogStack consists of a range of technologies designed to support modern, open source healthcare analytics, and is chiefly comprised of the Elastic stack ([ElasticSearch](https://www.elastic.co/products/elasticsearch), [Kibana](https://www.elastic.co/products/kibana), etc.), [MedCAT](https://github.com/CogStack/MedCAT) (clinical natural language processing for named entity extraction and linking, contextualization, and realtion extraction), clinical text [OCR](https://github.com/CogStack/ocr-service), and clinical text de-identification. Since the processed EHR data can be represented and stored in databases or ElasticSearch, CogStack can be perfectly utilised as one of the solutions for integrating EHR data with other types of biomedical, -omics, wearables data, etc.

---

## Community and support

- **Questions?** Reach out in the [CogStack community forum](https://discourse.cogstack.org/).
- **Code and projects:** [CogStack on GitHub](https://github.com/orgs/CogStack/repositories).

## Next Steps

[Get Started ](overview/getting-started.md){ .md-button .md-button--primary  }