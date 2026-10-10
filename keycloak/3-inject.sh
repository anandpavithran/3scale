# 1. Mount into Zync worker queues (handles client creation sync)
 oc set volume deployment/zync-que --add  --name=rhsso-ca --type=configmap  --configmap-name=rhsso-ca-bundle  --mount-path=/etc/pki/tls/certs/zync-ca-bundle.crt --sub-path=zync-ca-bundle.crt -n 3scale
# 2. Set environment variable so Zync recognizes the custom bundle
oc set env deployment/zync-que SSL_CERT_FILE=/etc/pki/tls/certs/zync-ca-bundle.crt -n 3scale
# 3. Mount into APIcast staging & production (handles JWT key fetching)
oc set volume deployment/apicast-staging --add  --name=rhsso-ca  --type=configmap --configmap-name=rhsso-ca-bundle  --mount-path=/etc/pki/tls/certs/rhsso-ca.crt --sub-path=zync-ca-bundle.crt  -n 3scale
oc set env deployment/apicast-staging SSL_CERT_FILE=/etc/pki/tls/certs/rhsso-ca.crt -n 3scale
