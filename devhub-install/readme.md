Steps to install DevHub on an OpenShift cluster. The installation allows for guest login/outside development and also has the placeholders required in order to make it authenticate with GitHub as well. 

1) Go to your Openshift console
2) Create a project named "backstage" (you can give any name you want, this is just an example)
3) Add a new configmap by importing the app-config-rhdh.yaml via the console or by oc apply -f app-config-rhdh.yaml . Note: don't care at this stage for the github authentication, we will just be using guest. 
4) Go to the developer view -> Helm, search for red hat developer hub. Select it and click create to create a helm release. 
   Then at the form view do the following:
     - Navigate to Root Schema -> global. Then under Enable service authentication within Backstage instance, enter the required shorthand, depending on the url of your cluster. In my case for example it is: apps.rosa.rosa-7j5h7.199j.p3.openshiftapps.com
     - Click Root Schema
     - Click Backstage Chart Schema 
     - Click Backstage Parameters.
     - Click Extra App Configuration files to inline into command arguments
     - Click + Extra App Configuration files to inline into command arguments
       Then for  configMapRef, enter: app-config-rhdh
       For filename enter: app-config-rhdh.yaml
     - Click create

     If you go to Topology you should see the pods coming up. When they are up go to the route that has been created for Dev Hub. Enter as Guest. In case you get any 401 errors and you cannot see the catalogue on Dev Hub, make sure that the ConfigMap is correct and the DevHub deployment uses it.

     If you want to be able to authenticate with your github handle you need to crate an OAuth app on github, an access key on Github with repo scope and add the required fields on the app-config-rhdh.yaml file. Then you need to scale down your app to zero replicas and then scale it back up in order to pick up the new values from the ConfigMap :


     1) Go to github.com , log in.
     2) Create a new classic token, give it a name and make sure you click the "repo" section and any other permission you want to authorize it for -  then  keep a note of the actual token value - copy/paste it somewhere safe because it won't show again when you navigate away from this page.
     3) Now, again at GitHub , create a new OAuth App. In the homepage Url, just fill it in with the route of your dev hub instance on your cluster. For the Callback Url you need to configure it like this : https://redhat-developer-hub-{namespace_name}.{openshift_route_host}/api/auth/github/handler/frame and then register the application.
     4) Now go to the configmap and update the values accordingly for access token , client id and client secret
     5) Scale down and up the application pod in order to pick up the new values.



     
     
     