#!/usr/bin/env bash
set -x

# remove nginx from image
sudo apt-get purge -y nginx nginx-common
sudo apt-get autoremove -y

# install pid manager
dumbinit_version=1.2.1
LOG="/vagrant/logs/envoy_${HOSTNAME}.log"
mkdir -p /vagrant/logs
sudo wget https://github.com/Yelp/dumb-init/releases/download/v${dumbinit_version}/dumb-init_${dumbinit_version}_amd64.deb \
    && sudo dpkg -i dumb-init_${dumbinit_version}_amd64.deb

# Added loop below to overcome Travis-CI download issue
RETRYDOWNLOAD="1"

while [ ${RETRYDOWNLOAD} -lt 5 ] && [ ! -f /usr/local/bin/envoy ]
do
    sudo mkdir -p /tmp/envoy
    pushd /tmp/envoy
    echo 'Envoy Binary Download' 
    # download binary and template file from latest release
    sudo bash -c 'curl -s https://api.github.com/repos/allthingsclowd/envoy_build_release/releases/latest \
    | grep "browser_download_url" \
    | cut -d : -f 2,3 \
    | tr -d \" | wget -q -i - '
    ls
    sudo tar -xvf envoy.tar.gz
    sudo mkdir -p /usr/local/bin && sudo cp envoy /usr/local/bin/envoy
    sudo mkdir -p /etc/envoy && sudo cp envoy.yml /etc/envoy/envoy.yaml
    sudo chmod +x /usr/local/bin/envoy
    popd
    RETRYDOWNLOAD=$[${RETRYDOWNLOAD}+1]
done


[  -f /usr/local/bin/envoy ] &>/dev/null || {
     echo 'Envoy Binary Download Failed'
     exit 1
}



ENVOY_LOG_LEVEL="info"
/usr/bin/dumb-init -- /usr/local/bin/envoy -l ${ENVOY_LOG_LEVEL} --log-path ${LOG} -c /etc/envoy/envoy.yaml &
sleep 10

curl -v localhost:9901/server_info

curl -v localhost:9901/stat

cat ${LOG}
