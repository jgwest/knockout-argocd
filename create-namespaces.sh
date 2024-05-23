#!/bin/bash

wd=$(dirname $(readlink -f $0))

for id in $(ls ${wd}/instances/); do
    oc create ns stresstest-$id
    oc label ns stresstest-$id argocd.argoproj.io/managed-by=argocd-stresstest
done