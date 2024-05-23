# argocd stresstest
Namespaced Argocd starts having performance issues when managing a medium number of applications and namespaces.

## Purpose
The intention of this repository is to simulate such a situation for testing the mentioned workarounds

## Tested environment
- Openshift 4.12.46
- openshift-gitops-1.11.2

## Setup
1. Generate some instance ids that are being used by the appset to create multiple instances. The first parameter is the desired number of instances 
`./generate-instances.sh 140`
- Commit and Push to your git repository

2. Create the managed namespaces with appropiate label (scoped argocd is not able to create namespace by itself)  
`./create-namespaces.sh`

3. Create the argocd instance  
- Adapt patches in `argocd-instance/base/kustomization.yaml` to your needs   
`oc kustomize argocd-instance/base | oc apply -f-`

## Cleanup
```
oc delete ns -l argocd.argoproj.io/managed-by=argocd-stresstest
oc delete ns argocd-stresstest
```