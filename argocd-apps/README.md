## ArgoCD configuration

After the installation of the OpenShift GitOps operator using the ACM policy, it is necessary to add a token to the ArgoCD instance to enable it to have read access to the summit-connect-2025 repository. Steps are below:

1. Login to the ArgoCD instance from the command line using the admin username and associated password:

````bash
argocd login --username admin --password $(oc get secret/openshift-gitops-cluster  -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d) --insecure --grpc-web $(oc get route/openshift-gitops-server -n openshift-gitops -o jsonpath='{.spec.host}')
````

 2. Add the Summit Connect 2025 repository to ArgoCD with an appropriate token that has read access to the repository.

````bash
argocd repo add https://github.com/marrober/summit-connect-2025.git.git --username <username> --password <token>
````
 
 3. Confirm that the repository has been added with the command:
 
````bash
argocd repo list
````