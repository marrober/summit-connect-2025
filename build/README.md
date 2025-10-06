## Instructions for building the applications with Tekton pipelines


### Enable public imagestreams

Issue the command below on the cluster to create public paths for imagestream content.

````bash
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
````

### Create a secret for Gitlab access

Create a secret on the OpenShift Cluster that enables the pipeline process to get access to the gitlab repository.

1. Generate a ssh key of type id_ed25519 or reuse an existing key-pair that does not have a pass phrase.

2. upload the ssh key public key to the gitlab in a users profile here : https://gitlab.consulting.redhat.com/-/user_settings/ssh_keys

3. Generate a secret in the format shown below :

````bash
apiVersion: v1
data:
  config: <base64 encoded version of the config file shown below>
  id_ed25519: <base64 encoded private key>
  known_hosts: <base64 encoded known hosts file that includes gitlab>
kind: Secret
metadata:
  name: git-credentials
  namespace: travel-ci
type: Opaque
````

Config file content

````bash
Host *
	StrictHostKeyChecking no

````

4. Apply the secret to the cluster and then build the pipelines

## Create a secret for access to the ACS CI/CD process

Generate the CI/CD token inside ACS. Go to Platform configurations -> Integrations -> Authentication tokens.
Generate a new CI/CD Scoped token.

Execute the following command :

````bash
oc create secret generic acs-secret \
--from-literal=acs_api_token=<token from above step> \
--from-literal=acs_central_endpoint=$(oc get route/central -n stackrox -o jsonpath='{.spec.host}{":443"}')
````

## ACS read the Openshift Image Registry

````bash
oc get sa/image-pusher -o yaml | grep image-pusher-dockercfg
````

### Create a long lived token

To create a token that will not time out quickly use the command below. This will create a token that will last 625 days.

````bash
oc create token image-pusher --duration=15000h --bound-object-kind Secret --bound-object-name image-pusher-dockercfg-<whatever>
````

Get the default route : 

````bash
 oc get is/rhel9-nodejs-16 -o jsonpath='{"https://"}''{.status.publicDockerImageRepository}' | cut -d "/" -f 1-3
 ````

In ACS go to Platform configurations -> Integrations -> Image integration -> Generic Docker Registry and press the ‘Create integration’ button.
Fill in the details as :
	Integration name : OCP Registry
	Endpoint : https://default-route-openshift-image-registry.apps.cluster-.....
	Username : admin
	Password : token from above
	Check the option : Disable TLS certificate validation (insecure)
Test the integration and save if successful.

## Create secret for quay.io commit

Create a secret with a dockerconfigjson token to give access to write to the repositories in quay.io in the format shown below:

````bash
apiVersion: v1
kind: Secret
metadata:
  name: quay-auth-secret
data:
  .dockerconfigjson: <base64 encoded token>
type: kubernetes.io/dockerconfigjson
````