# Helm chart for nfs-provisioner

This is a Helm chart for [nfs-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs).

## Reasons to use

To my knowledge, **nfs-provisioner** is the easiest way to deploy a storage provisioner (which fulfills Persistent Volume Claims) on a Kubernetes clusters running on standalone bare metal machine, using local system storage.

In a cloud environment, it may be used to optimize disk usage and IOPS costs. For that, **nfs-provisioner** may allocate a *single* Persistent Volume of certain size (e.g. 100gig) from a cloud native provisioner (such as EBS), then fullfil multiple local Persistent Volume Claims of any size that will share that single EBS volume.

## Requirements

* Kubernetes 1.6+
* PSP not enabled
* Helm

It is highly recommended that you enable RBAC.

## Installation

```sh
helm repo add nfs-provisioner https://raw.githubusercontent.com/IlyaSemenov/nfs-provisioner-chart/master/repo
helm install --name nfs-provisioner --namespace nfs-provisioner nfs-provisioner/nfs-provisioner
```

## Configuration

The following defaults are used. You can override them with `--set variable=value`, or with `--values myvalues.yaml`.

### `image`

Default: `quay.io/kubernetes_incubator/nfs-provisioner:v1.0.8`

## `rbac.enabled`

To disable RBAC support, set this to false. It is recommended that you use RBAC
and leave this enabled. However, you can disable it to create your own RoleBinding
and Role.

Default: true

### `provisionerName`

Default: `local.net/nfs`

### `storageClass`

Default: `local-nfs`

### `hostPath`

If this is empty, no local storage will be used, making this completely emphemeral.

Default: `/srv/nfs-provisioner`

### `useTmpfs`

If hostPath is empty and this is set to true, the NFS server will use memory-based
tmpfs storage instead of allocating disk. This is very fast and very volatile, and
has the additional risk of consuming cluster memory resources. It will not persist
across a node restart.

Default: false

### `defaultClass`

Whether to mark this storage provisioner as default. If set to `true`, unlabelled Persistent Volume Claims will use this provisioner.

Default: `false`

## TODO

* [ ] Dynamically name resources (allow to run multiple provisioners simultaneously)
* [ ] Support storage volume types other than `hostPath` (e.g. other persistent volumes)
* [X] Support clusters without RBAC?
* [ ] Support PSP?

PRs are welcome.
