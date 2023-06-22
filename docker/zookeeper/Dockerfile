FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        openjdk-8-jre \
        wget \
    && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O- https://dlcdn.apache.org/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1-bin.tar.gz | tar -zx -f- -C /opt \
    && mv /opt/apache-zookeeper-3.8.1-bin /opt/zookeeper

ENV PATH=/opt/zookeeper/bin:$PATH
COPY zoo.cfg /opt/zookeeper/conf/zoo.cfg

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]