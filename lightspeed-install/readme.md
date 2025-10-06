In order to install OpenShift lightspeed, follow the below: 

Please note that we will be using a granite llm as the llm of choice in that case, but you can use anything you want as long as you have the correct api key and service url in place.

1) Go to Operators Catalogue and locate OpenShift Lightspeed. Click install.
2) Create a new secret from credentials.yaml and fill the required fields as required.
3) Then go to Installed Operators and click at OpenShift LightSpeed -> Create new Instance
4) Select to view as yaml and copy paste the contents of the cluster.yaml or oc apply -f cluster.yaml if you are on cli.


After a few minutes a new icon on the bottom right should appear which indicates that OpenShift LightSpeed is running.

Note: Make sure that your model name and default model name are correct on your OLS config file - in this case cluster.yaml file