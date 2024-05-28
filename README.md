# knockout-argocd 
It was emphasized that a namespaced Argocd instance, instatiated by [openshift-gitops operator](https://docs.openshift.com/gitops/1.11/understanding_openshift_gitops/about-redhat-openshift-gitops.html), starts having performance issues when managing a medium number of applications and namespaces. This can end up in a endless locked situation.

## Purpose
The intention of this repository is to prove the behaviour and for testing workarounds.
Possible workarounds: https://access.redhat.com/solutions/7006291

## Tested environment
- Openshift 4.12.46
- openshift-gitops-1.11.2

## Reproducer
0. Fork this repository on GitHub and `git clone` it locally

1. Generate some instance-ids that are being used by the appset to create multiple instances. The first parameter is the desired number of instances  
`./generate-instances.sh 50`
- Commit and Push it to GitHub (minimum instances and stresstest dirs)

2. Create the managed namespaces with appropiate label (scoped argocd is not able to create namespace by itself)  
`./create-namespaces.sh`

3. Create the argocd instance  
- Adapt patches in `argocd-instance/base/kustomization.yaml` to your needs   
`oc kustomize argocd-instance/base | oc apply -f-`

4. Check the Argo CD UI or check the applications that all Argo CD Apps are synced and healthy

5. Generate more 20 instances, commit and push them:
`./generate-instances.sh 20 && git add instances/ && git commit -m "Add 20 more instances for reproducer"`

6. To reproduce the issue, execute the `create-namespaces` script:
`./create-namespaces.sh`

Observe that the Argo CD `argocd-application-controller` will show the following messages and will no longer sync:

```
E0528 08:11:05.560835 1 retrywatcher.go:130] "Watch failed" err="context canceled"
E0528 08:11:05.560958 1 retrywatcher.go:130] "Watch failed" err="context canceled"
E0528 08:11:05.561083 1 retrywatcher.go:130] "Watch failed" err="context canceled"
E0528 08:11:05.561145 1 retrywatcher.go:130] "Watch failed" err="context canceled"
E0528 08:11:05.561179 1 retrywatcher.go:130] "Watch failed" err="context canceled"
```

You can also try to "Sync" an Application in the Argo CD UI, this will not work as expected.

## Cleanup
```
oc delete appset stresstest -n argocd-stresstest
oc delete ns -l argocd.argoproj.io/managed-by=argocd-stresstest
oc delete ns argocd-stresstest
rm -rf instances/*
```
