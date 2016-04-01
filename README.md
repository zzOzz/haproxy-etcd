

WorkFlow

Docker-gen -> etcd write -> confd -> reload haproxy


docker-compose run --rm --entrypoint sh haproxy


sudo /usr/bin/bash -c "sed -i 's/'$(hostname)'/'$(hostname)' clusterpp/g' /etc/hosts"
