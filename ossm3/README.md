# Manual install of travel app

This is a set of manual steps to deploy the travel app in pods.o

## Install Operators

From Operator Hub install these operators:

• Install kiali operator
• Install Service Mesh 3 (version 3.0.2)

## Deploy istio control plane

Create namespaces:

```
oc new-project istio-system
oc new-project istio-cni
```

Deploy controlplane.

```
oc apply -f istio-controlplane.yaml
```

Deploy istio CNI.

```
oc apply -f istio-cni.yaml
```

## Deploy Kiali

Enable monitoring for user workloads

```
oc apply -f user-monitoring.yaml
```

Create servicemonitor:

```
oc apply -f servicemonitor.yaml
```

Create rolebinding for Kiali to view metrics:

```
oc apply -f kiali-rolebinding.yaml
```

Deploy Kiali.

```
oc apply -f kiali.yaml
```

## Deploy travel app

Create app namespaces.

``` 
oc new-project travel-agency
oc new-project travel-portal
oc new-project travel-control
```

Label namespaces for sidecar injection:

```
oc label namespace travel-agency istio-injection=enabled
oc label namespace travel-portal istio-injection=enabled
oc label namespace travel-control istio-injection=enabled
```


# Enable 

Enable mesh namespace monitoring with pod monitor:

```
oc apply -f agency-podmonitor.yaml
oc apply -f control-podmonitor.yaml
oc apply -f portal-podmonitor.yaml
```

Deploy apps:

```
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_agency.yaml) -n travel-agency
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_portal.yaml) -n travel-portal
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_control.yaml) -n travel-control
```

# Deploy istio gateway

```
oc apply -f gateway-deploy.yaml
oc apply -f gateway.yaml
```

# Expose app

```
oc expose svc travelgateway --port 80
```

# Login to kiali and check the application

Get the route for the app and check it is working:

```
oc get route travelgateway -n travel-control
```

Get the route for Kiali and use OCP credentials to login:

```
oc get route kiali -n istio-system
```

## Replacing cars pod with a VM

Scale down the cars deployment:

```
oc scale deployment cars-v1 --replicas=0 -n travel-agency
```

Deploy cars VM:

```
oc apply -f cars-vm.yaml
```

If you scale up the pod you'll see traffic going between both pod and VM as well:

```
oc scale deployment cars-v1 --replicas=1 -n travel-agency
```

