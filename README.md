# Helm chart for nfs-provisioner

This is a Helm chart for [nfs-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs).

## Reasons to use

To my knowledge, **nfs-provisioner** is the easiest way to deploy a storage provisioner (which fulfills Persistent Volume Claims) on a Kubernetes clusters running on standalone bare metal machine, using local system storage.

In a cloud environment, it may be used to optimize disk usage and IOPS costs. For that, **nfs-provisioner** may allocate a *single* Persistent Volume of certain size (e.g. 100gig) from a cloud native provisioner (such as EBS), then fullfil multiple local Persistent Volume Claims of any size that will share that single EBS volume.

## Requirements

* Kubernetes 1.6+
* RBAC enabled
* PSP not enabled
* Helm

## Installation

```sh
helm repo add nfs-provisioner https://raw.githubusercontent.com/IlyaSemenov/nfs-provisioner-chart/master/repo
helm install --name nfs-provisioner --namespace nfs-provisioner nfs-provisioner/nfs-provisioner
```

## Configuration

The following defaults are used. You can override them with `--set variable=value`, or with `--values myvalues.yaml`.

### `image`

Default: `quay.io/kubernetes_incubator/nfs-provisioner:v1.0.8`

### `provisionerName`

Default: `local.net/nfs`

### `storageClass`

Default: `local-nfs`

### `hostPath`

Default: `/srv/nfs-provisioner`

### `defaultClass`

Whether to mark this storage provisioner as default. If set to `true`, unlabelled Persistent Volume Claims will use this provisioner.

Default: `false`

## TODO

* [ ] Dynamically name resources (allow to run multiple provisioners simultaneously)
* [ ] Support storage volume types other than `hostPath` (e.g. other persistent volumes)
* [ ] Support clusters without RBAC?
* [ ] Support PSP?

PRs are welcome.
