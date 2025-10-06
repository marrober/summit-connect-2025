# Manual install of travel app

This is a set of manual steps to deploy the travel app in pods.o

## Install Operators

From Operator Hub install these operators (Default values for all):

• Install kiali operator
• Install Service Mesh 2

## Deploy istio control plane

Create namespace:

```
oc new-project istio-system
```

Deploy controlplane.

```
oc apply -f istio-controlplane.yaml
```

Kiali should be working now - get the route and log in:

```
oc get route kiali -n istio-system
```

## Deploy travel app

Create app namespaces.

``` 
oc new-project travel-agency
oc new-project travel-portal
oc new-project travel-control
```

Deploy apps:

```
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_agency.yaml) -n travel-agency
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_portal.yaml) -n travel-portal
oc apply -f <(curl -L https://raw.githubusercontent.com/kiali/demos/master/travels/travel_control.yaml) -n travel-control
```

## Configure app for servicemesh

Add namespaces as servicemesh members:

```
oc apply -f smesh-members.yaml
```

We need to patch the deployments to deploy sidecars. Run script to patch deployments and restart:

```
sh patch-deployments.sh
```

Expose application:

```
oc apply -f expose-app.yaml
```

Check if app is exposed. Get the gateway route:

```
oc get route istio-ingressgateway -n istio-system
```

Open browser to the route - should see the travel app. App should be constantly updating with activity.

**NOTE** this might take a moment to update. Check kiali UI again. Go to graph and select all 3 of the travel- namespaces. On the "Display" drop-down, select "traffic animation". Should see traffic flowing.

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
