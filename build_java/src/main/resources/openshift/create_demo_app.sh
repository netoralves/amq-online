set -x

AMQ_ONLINE_INFRA_PROJ=amq-online-infra
AMQ_ONLINE_DEMO_PROJ=amqp-demo

#OPTIONS: demo-objects-standard.yaml / demo-objects-standard-external.yaml / demo-objects-brokered.yaml / demo-objects-brokered-external.yaml
AMQ_ONLINE_PROFILE=demo-objects-standard-external.yaml


#OPTIONS: if use demo-objects-standard* = demo-standard-space / if use demo-objects-brokered* = demo-brokered-space
AMQ_ONLINE_ADDRESSSPACE=demo-standard-space


output=$(oc get project ${AMQ_ONLINE_DEMO_PROJ})

if [ -z "${output}" ]; then
    echo "project doesn't exists." 
    oc new-project ${AMQ_ONLINE_DEMO_PROJ}
fi

echo "Proceeding"

oc apply -f src/main/resources/openshift/${AMQ_ONLINE_PROFILE} -n ${AMQ_ONLINE_DEMO_PROJ}

oc get routes console -o jsonpath={.spec.host} -n ${AMQ_ONLINE_INFRA_PROJ}

sleep 5

oc get addressspace ${AMQ_ONLINE_ADDRESSSPACE} -o 'jsonpath={.status.endpointStatuses[?(@.name=="messaging")].externalHost}' -n ${AMQ_ONLINE_DEMO_PROJ}
