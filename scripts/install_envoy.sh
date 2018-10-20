#!/usr/bin/env bash
set -x


# Added loop below to overcome Travis-CI download issue
RETRYDOWNLOAD="1"

while [ ${RETRYDOWNLOAD} -lt 5 ] && [ ! -f /usr/local/bin/envoy/envoy ]
do
    sudo mkdir -p /tmp/envoy
    pushd /tmp/envoy
    echo 'Envoy Binary Download' 
    # download binary and template file from latest release
    sudo bash -c 'curl -s https://api.github.com/repos/allthingsclowd/envoy_build_release/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" | wget -q -i - '
    sudo tar -xvf envoy.tar.gz .
    cp -rp envoy /usr/local/bin/envoy/envoy
    cp -rp envoy.yml /etc/envoy/envoy.yaml
    chmod +x /usr/local/bin/envoy/envoy
    popd
    RETRYDOWNLOAD=$[${RETRYDOWNLOAD}+1]
    sleep 5
done


[  -f /usr/local/bin/envoy/envoy  ] &>/dev/null || {
     echo 'Web Front End Download Failed'
     exit 1
}

/usr/local/bin/envoy --v2-config-only -l $loglevel -c /etc/envoy/envoy.yaml &

curl -v localhost:10000