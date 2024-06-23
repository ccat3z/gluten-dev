FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        openjdk-8-jre \
        wget \
    && \
    rm -rf /var/lib/apt/lists/*

ARG ZOOKEEPER_VERSION=3.9.2
RUN wget -O- https://dlcdn.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz | tar -zx -f- -C /opt \
    && mv /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin /opt/zookeeper

ENV PATH=/opt/zookeeper/bin:$PATH
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]