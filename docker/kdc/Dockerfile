FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        krb5-kdc \
        krb5-admin-server \
    && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/krb5
COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY krb5.conf.template /etc/krb5.conf.template
COPY kdc.sh /kdc.sh

ENTRYPOINT /kdc.sh