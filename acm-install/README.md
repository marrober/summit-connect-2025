# Installation of ACM on Summit Connect 2025 clusters

## Hub Cluster

On the cluster which is to be the ACM hub follow the instructions below. 

1. Install the ACM operator on the cluster by searching for the operator called 'Advanced Cluster Management for Kubernetes'. Take the default options to install the operator in the open-cluster-management namespace. Detailed information is available [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.14/html-single/install/index#installing-from-the-operatorhub).

2. After the installation of the operator on the hub you will be taken to the operator console for the creation of the multi-cluster hub. Create a new instance of the multi-cluster hub taking all default options. 

3. Ensure that the web user interface updates and you get the menu showing 'local-cluster' or 'All clusters' next to the OpenShift logo.

## Adding managed clusters

To add existing clusters as managed clusters perform the following steps.

1. In the 'All Clusters' perspective of the OpenShift hub cluster web user interface, select the infrastructure menu and then select clusters.

2. Select the 'Import cluster' button and fill out the first page with an appropriate name. Ensure that the import mode is set to 'Run import commands manually'. 

3. Press next until you get a blue button at the bottom of the screen showing 'Generate command'. Press this button and then press the copy button to capture the command in the laptop copy/paste buffer.

4. Switch to a command line window which as a kubernetes context of the cluster that you wish to import and ensure that you are logged in as the cluster admin user. 

5. Paste the copied command and wait while it runs. Check back on the ACM cluster list and wait for the cluster to appear.

