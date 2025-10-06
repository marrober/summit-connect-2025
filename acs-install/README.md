# Installation of ACS on Summit Connect 2025 clusters

## Hub Cluster

On the cluster which is to host the main Central component for ACS follow the instructions below. 

1. Install the ACS operator on the cluster by searching for the operator called 'Advanced Cluster Security for Kubernetes'. Take the default options to install the operator in the rhacs-operator namespace. Detailed information is available [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_security_for_kubernetes/4.8/html-single/installing/index#install-acs-operator_install-central-ocp).

2. Create a namespace called 'stackrox' and wait for the operators to register in the operator.

3. Select the ACS operator from the list of installed operators and from the submenu (beginning with Details, YAML, Subscription etc.) select 'Central'. Click the blue button to create an instance of Central.Take all default options and press the 'Create' button.

4. Wait for the condition to change to 'Deployed, Initialized'.

5. Check the pods to see that all are running. If the cluster is sized well there will be no problem but on smaller clusters it is necessary to scale back the resource requirements of some components. If pods do not start because they are starved of resources then carry out the following steps. Go to the ACS operator in the stackrox namespace. Select the Central tab and select the instance called 'stackrox-central-services'. Select the yaml view and add the following under the spec.central.db section if the central db has not started. If any other components have failed to start repeat this step in the appropriate block of yaml.

````bash
      resources:
        limits:
          cpu: '4'
          memory: 4Gi
        requests:
          cpu: '1'
          memory: 1Gi
````

6. Get the admin password from the secret called central-htpasswd using the command : 

````bash
oc get secret/central-htpasswd -n stackrox -o jsonpath='{.data.password}' | base64 -d
````

7. get the route for web UI access with the command :

````bash
oc get route/central -n stackrox -o jsonpath='{"https://"}{.spec.host}{"\n"}'
````

## Adding secured clusters

### Generate the cluster-init bundle for all secured clusters.

1. After logging into Central for the fist time you are probably taken to the screen to add secured clusters. If not got to the url : <central-url>/main/clusters.

2. Give the init bundle the name 'acs-init' and ensure OpenShift is selected. Download the init bundle to your local machine. The file will be downloaded to with the name acs-init-Operator-secrets-cluster-init-bundle.yaml. 

### Apply the init bundle to the hub cluster

Install the init bundle on the hub cluster using the command:

````bash
oc project stackrox
oc apply -f acs-init-Operator-secrets-cluster-init-bundle.yaml
````

### Add the hub as a secured cluster

1. Select the installed operators on the left hand side menu and the select the ACS operator. Ensure that you are in the stackrox namespace.

2. Select the Secured Clusters sub-tab and then select the 'Create SecuredCluster' button.

3. In the form view two fields need specific values :

* Cluster name : Enter 'hub-cluster' for the hub.
* Central endpoint : Enter the address of the central server without the https:// prefix and with :443 appended. Use the command below to get the route in this format.

````bash
oc get route/central -n stackrox -o jsonpath='{.spec.host}{":443\n"}'
````

4. Check the pods in the stackrox namespace and if any are stuck starting due to memory constraints change the resource requirements of the entity within the yaml definition of the secured cluster object. This object is located in the installed operator (ACS) in the stackrox namespace. The sensor container in the sensor deployment may suffer from this and if that happens reduce the resources as below (snippet):

````bash
apiVersion: platform.stackrox.io/v1alpha1
kind: SecuredCluster

  resourceVersion: '1038183'
  name: stackrox-secured-cluster-services
  namespace: stackrox


spec:
  sensor:
    resources:
      limits:
        cpu: '2'
        memory: 4Gi
      requests:
        cpu: '1'
        memory: 1Gi
````

5. When all pods have started go to the platform configuration -> Clusters view in the ACS web UI to check that the cluster is visible and healthy.

### Secure subsequent clusters

1. For further secured clusters begin by installing  the ACS operator from the operator hub.

2. Create a new namespace called stackrox. 

3. Apply the init bundle to create the resources in the stackrox namespace.

4. Select the installed operators on the left hand side menu and the select the ACS operator. Ensure that you are in the stackrox namespace.

5. Select the Secured Clusters sub-tab and then select the 'Create SecuredCluster' button.

6. In the form view two fields need specific values :

* Cluster name : Enter an appropriate name to identify the cluster.
* Central endpoint : Enter the address of the central server without the https:// prefix and with :443 appended. 

7. Check the pods in the stackrox namespace and if any are stuck starting due to memory constraints change the resource requirements of the entity within the yaml definition of the secured cluster object. This object is located in the installed operator (ACS) in the stackrox namespace. The sensor container in the sensor deployment may suffer from this and if that happens reduce the resources as below (snippet):

````bash
apiVersion: platform.stackrox.io/v1alpha1
kind: SecuredCluster

  resourceVersion: '1038183'
  name: stackrox-secured-cluster-services
  namespace: stackrox


spec:
  sensor:
    resources:
      limits:
        cpu: '2'
        memory: 4Gi
      requests:
        cpu: '1'
        memory: 1Gi
````

8. When all pods have started on the hub cluster go to the platform configuration -> Clusters view in the ACS web UI to check that the cluster is visible and healthy.



