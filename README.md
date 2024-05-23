# argocd stresstest
Namespaced Argocd starts having performance issues when managing a medium number of applications and namespaces.

## Purpose
The intention of this repository is to simulate such a situation for testing the mentioned workarounds

## Tested environment
- Openshift 4.12.46
- openshift-gitops-1.11.2

## Setup
1. Generate some instance ids that are being used by the appset to create multiple instances.
`./generate-instances.sh 140`
- Commit and Push to your git repository

2. Create managed namespaces with appropiate label (scoped argocd is not able to create namespace by itself)  
`./create-namespaces.sh`

3. Create the argocd instance  
- Replace CHANGEME occurances in argocd.yaml and appset.yaml  
- Add the source repository and privatekey as a secret  
`oc kustomize argocd-instance/base | oc apply -f-`
