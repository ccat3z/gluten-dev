FROM centos:7

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=http://mirrors.edge.kernel.org/centos/|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf 

WORKDIR /tmp/vcpkg
COPY setup-build-depends.sh setup-build-depends.sh
RUN ./setup-build-depends.sh
RUN echo ". /opt/rh/devtoolset-9/enable" > /etc/profile.d/devtoolset-9.sh

WORKDIR /
RUN rm -rf /tmp/vcpkg

ENV VCPKG_BINARY_SOURCES=default

COPY <<EOF /entrypoint
#! /bin/sh

set -ex

if [ -n "\$BUILDER_UID" ] && [ "\$BUILDER_UID" != 0 ]; then
    if [ -n "\$BUILDER_GID" ]; then
        getent group "\$BUILDER_GID" || groupadd -g "\$BUILDER_GID" builder
    else
        echo "BUILDER_GID is required if BUILDER_UID is provide" >&2
        exit 1
    fi

    id -u builder &>/dev/null || useradd -m -u "\$BUILDER_UID" -g "\$BUILDER_GID" builder

    chown "\$BUILDER_UID:\$BUILDER_GID" "/home/builder"
fi

exec "\$@"
EOF

ENTRYPOINT ["/bin/sh", "/entrypoint"]
CMD ["sleep", "inf"]