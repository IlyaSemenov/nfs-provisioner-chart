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

### `rbac.enabled`

To disable RBAC support, set this to false. It is recommended that you use RBAC
and leave this enabled. However, you can disable it to create your own RoleBinding
and Role.

Default: `true`

### `provisionerName`

Default: `local.net/nfs`

### `storageClass`

Default: `local-nfs`

### `provisionerVolume.mode` and `provisionerVolume.settings`

There are a number of modes you can use. These are the available options.

| Mode                 | Description                                                                                                                                                                                       | Available settings                                                         |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `hostPath` (default) | A hostPath volume mounts a file or directory from the host node’s filesystem into your pod: <https://kubernetes.io/docs/concepts/storage/volumes/#hostpath>                                       | <ul><li> `path`: "/directory/location/on/host" (defaults to `/srv/nfs-provisioner`)</li></ul> |
| `tmpFs`              | mount a tmpfs (RAM-backed filesystem) instead of using the host node's storage or a PVC. This is very fast and very volatile but might be useful for things like caches and temporary workspaces. | none                                                                       |
| `emptyDir`           | An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node: <https://kubernetes.io/docs/concepts/storage/volumes/#emptydir>     | none                                                                       |
| `pvc`                | Make a Persistent Volume Claim for the nfs-provisioner: <https://kubernetes.io/docs/concepts/storage/persistent-volumes/>                                                                         | <ul><li>`storageSize`: "5Gi" (defaults to 1Gi)</li></ul>                                     |

To set a mode, set the `provisionerVolume.mode` value. For instance:

```console
--set provisionerVolume.mode=pvc
```

To adjust settings, set the `provisionerVolume.settings.<setting_name>` value. For instance:

```console
--set provisionerVolume.settings.storageSize=5gi
```

### `defaultClass`

Whether to mark this storage provisioner as default. If set to `true`, unlabelled Persistent Volume Claims will use this provisioner.

Default: `false`

### `hostPath`

**REMOVED**
Please use the following configuration instead.

```yaml
provisionerVolume:
  mode: "hostPath"
```

### `useTmpfs`

**REMOVED**
Please use the following configuration instead.

```yaml
provisionerVolume:
  mode: "tmpFs"
```

## TODO

* [ ] Dynamically name resources (allow to run multiple provisioners simultaneously)
* [ ] Support PSP?

PRs are welcome.
