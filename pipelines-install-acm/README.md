# Installation of OpenShift Pipelines operator with ACM

The placement policy will install on all ACM registered clusters that have the cluster label :

````bash
vendor=OpeShift
````

To install the operator use the command : 

````bash
oc apply -f pipelines-install-acm/
````