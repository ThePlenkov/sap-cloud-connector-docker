# SAP cloud connector (Docker + Kubernetes)

This project combines Docker and Kubernetes experience with SAP Cloud Connector

Key feature of the current implementation - is supporting persistent volume to be able to keep configuration apart of the container

## How to use with docker

In this example we create scc_cache folder (can be any name) to use it as our persistent volume. Target folder /scc is predefined. Is not required and may be omitted.

We also use port-forwarding to expose container port to localhost

```shell
mkdir scc_cache
docker run -p 8443:8443 --mount type=bind,source=${PWD}/scc_cache,target=/scc ghcr.io/theplenkov/sap-cloud-connector:latest
```

## How to use with Kubernetes

It is also possibe to install SAP cloud connector with Kubernetes just with one line. In this case it will request persistend volume and will use it to store settings. If you decide to update version, that new version will be applied to deployment but you config will be restored from the backup

```bash
kubectl apply -f https://raw.githubusercontent.com/ThePlenkov/sap-cloud-connector-docker/master/k8s/scc-deployment.yaml
```
