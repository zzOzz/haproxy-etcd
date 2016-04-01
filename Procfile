dockergen: docker-gen -watch -only-exposed -notify "bash /bin/write_etcd.sh" /app/write_etcd.tmpl /bin/write_etcd.sh
confd: confd -node "https://$(ip route|grep default|cut -d' ' -f3):4001" -client-ca-keys=/etc/ssl/ca.pem -client-cert=/etc/ssl/server.pem -client-key=/etc/ssl/server-key.pem
