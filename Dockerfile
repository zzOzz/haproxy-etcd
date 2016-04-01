FROM haproxy:alpine
MAINTAINER Vincent Lombard vincent.lombard+haproxy_etcd@gmail.com

# Install Forego
ENV GOPATH /app/
RUN apk add --update curl bash git go && rm -rf /var/cache/apk/* && go get -u github.com/ddollar/forego

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.7.0
RUN curl -s -L https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz -o docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz\
  && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
  && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

#install ETCDCTL
ENV ETCD_VERSION 2.3.0
RUN curl -s -L https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz -o /tmp/etcd-v$ETCD_VERSION-linux-amd64.tar.gz\
&& cd /tmp/\
&& tar xzf etcd-v$ETCD_VERSION-linux-amd64.tar.gz\
&& rm -f etcd-v$ETCD_VERSION-linux-amd64.tar.gz\
&& mv /tmp/etcd-v$ETCD_VERSION-linux-amd64/etcdctl /usr/local/bin

#install confd
ENV CONFD_VERSION 0.7.1
RUN curl -s -L https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VERSION/confd-$CONFD_VERSION-linux-amd64 -o /bin/confd && \
	chmod +x /bin/confd

COPY . /app/
WORKDIR /app/
ADD confd /etc/confd
ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/haproxy/certs"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/app/bin/forego", "start", "-r"]
