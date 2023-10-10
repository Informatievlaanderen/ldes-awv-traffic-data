#!/bin/bash
export SCRIPT_PATH=$(dirname -- "$( readlink -f -- "${BASH_SOURCE:-$0}"; )")
export LDES_PATH=$SCRIPT_PATH/ldes

curl --fail -X POST 'http://localhost:8080/admin/api/v1/eventstreams' -H 'Content-Type: text/turtle' -d "@$LDES_PATH/measurement-points.ttl"
code=$?
if [ $code != 0 ] 
    then exit $code
fi

curl --fail -X POST 'http://localhost:8080/admin/api/v1/eventstreams/measurement-points/views' -H 'Content-Type: text/turtle' -d "@$LDES_PATH/measurement-points-by-location.ttl"
code=$?
if [ $code != 0 ] 
    then exit $code
fi

curl --fail -X POST 'http://localhost:8080/admin/api/v1/eventstreams' -H 'Content-Type: text/turtle' -d "@$LDES_PATH/observations.ttl"
code=$?
if [ $code != 0 ] 
    then exit $code
fi

curl --fail -X DELETE 'http://localhost:8080/admin/api/v1/eventstreams/observations/views/by-page'
code=$?
if [ $code != 0 ] 
    then exit $code
fi

curl --fail -X POST 'http://localhost:8080/admin/api/v1/eventstreams/observations/views' -H 'Content-Type: text/turtle' -d "@$LDES_PATH/observations-by-page.ttl"
code=$?
if [ $code != 0 ] 
    then exit $code
fi
