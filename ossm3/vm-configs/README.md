# Cars VM template

The cars-vm-blueprint.toml file can be used with RHEL image builder to create the template. There were some manual workarounds required to get it working. 

Boot a VM with the QCOW created from the image build process. Run the following commands:

```
podman system reset
podman pull quay.io/kiali/demo_travels_cars:v1
```

Shut the VM down and then seal it with virt-sysprep.

## Build Container

Use the Containerfile in this directory to build a container image:

```
podman build -t <tag> -f Containerfile
```

Push the resulting image to a registry.

## Add new datasource to CNV

Patch the cluster hyperconverged resource with a new dataimport configuration to import our cars-vm boot image.

```
oc -n openshift-cnv patch hyperconverged kubevirt-hyperconverged   --type merge --patch-file datasource.yaml
```

##

Add a new template to the catalog

Apply the template to the cluster:

```
oc apply -f cars-vm-template.yaml
```
