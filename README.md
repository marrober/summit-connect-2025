# Order of installation tasks

1. Install ACM - [link](https://github.com/marrober/summit-connect-2025.git/-/blob/main/acm-install/README.md?ref_type=heads)
2. Install ACS - [link](https://github.com/marrober/summit-connect-2025.git/-/blob/main/acs-install/README.md?ref_type=heads)
3. Install GitOps - [link](https://github.com/marrober/summit-connect-2025.git/-/tree/main/gitops-install-acm?ref_type=heads)
4. Install Pipelines - [link](https://github.com/marrober/summit-connect-2025.git/-/blob/main/pipelines-install-acm/README.md?ref_type=heads)
5. Configure the ArgoCD instance for access to the repository - [link](https://github.com/marrober/summit-connect-2025.git/-/tree/main/argocd-apps?ref_type=heads)
6. Install Service Mesh - [link](https://github.com/marrober/summit-connect-2025.git/-/blob/main/kustomization.yaml?ref_type=heads)
    Use oc apply -K within the root of the ssa-summit-connect-2025 directory. This will install the service mesh components and the main ArgoCD project and applications.