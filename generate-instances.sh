#!/bin/bash

n=120
if [ -n "$1" ]; then
    n=$1
fi

wd=$(dirname $(readlink -f $0))

for i in $(seq 1 $n); do
    id=$(echo $RANDOM | md5sum | head -c 10; echo)
    mkdir -p ${wd}/instances/$id
    echo "{ 'id': '${id}' }" > ${wd}/instances/$id/config.json
done

echo "Created $n new instances in ${wd}/instances"
