#!/bin/bash
: ${CLOUD=""} # One of aws, azure, do, gcp, or empty
if [ "$CLOUD" != "" ]; then
   PROVIDER="-provider ${CLOUD}"
fi

PRIVATE_IPV4=$(netdiscover -field privatev4 ${PROVIDER})
PUBLIC_IPV4=$(netdiscover -field publicv4 ${PROVIDER})
if [[ -z "${BIND_ADDR}" ]]; then
   export BIND_ADDR="udp:127.0.0.1:7722"
fi
if [[ -z "${UDP_PORT_RANGE_LOW}" ]]; then
   export UDP_PORT_RANGE_LOW="30000"
fi
if [[ -z "${UDP_PORT_RANGE_HIGH}" ]]; then
   export UDP_PORT_RANGE_HIGH="40000"
fi
if [[ -z "${LOG_LEVEL}" ]]; then
   export LOG_LEVEL="INFO"
fi

#RTPPROXY_ARGS="-F -f -m 10000 -M 20000 -s udp:127.0.0.1:22222 -l ${PRIVATE_IPV4} -d DBUG:LOG_LOCAL0"
RTPPROXY_ARGS="-f -A ${PUBLIC_IPV4} -F -l ${PRIVATE_IPV4} -m ${UDP_PORT_RANGE_LOW} -M ${UDP_PORT_RANGE_HIGH} -s ${BIND_ADDR} -d ${LOG_LEVEL}"
echo "RTP proxy args are: ${RTPPROXY_ARGS}"

# Run rtpproxy
/usr/bin/rtpproxy ${RTPPROXY_ARGS}
