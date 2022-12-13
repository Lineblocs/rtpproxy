#!/bin/bash
: ${CLOUD=""} # One of aws, azure, do, gcp, or empty
if [ "$CLOUD" != "" ]; then
   PROVIDER="-provider ${CLOUD}"
fi

PRIVATE_IPV4=$(netdiscover -field privatev4 ${PROVIDER})
PUBLIC_IPV4=$(netdiscover -field publicv4 ${PROVIDER})

#RTPPROXY_ARGS="-F -f -m 10000 -M 20000 -s udp:127.0.0.1:22222 -l ${PRIVATE_IPV4} -d DBUG:LOG_LOCAL0"
RTPPROXY_ARGS="-f -A ${PUBLIC_IPV4} -F -l ${PRIVATE_IPV4} -m 30000 -M 40000 -s udp:127.0.0.1:7722 -d INFO"

# Run rtpproxy
/usr/bin/rtpproxy ${RTPPROXY_ARGS}
