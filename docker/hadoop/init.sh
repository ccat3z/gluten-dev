#! /bin/bash

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/sbin/sshd-keygen
fi

if [ -n "$HDFS_UID" ] && [ -n "$HDFS_GID" ]; then
    if [ -n "$HDFS_GID" ]; then
        getent group "$HDFS_GID" || groupadd -g "$HDFS_GID" hdfs
    else
        echo "HDFS_GID is required if HDFS_UID is provide" >&2
        exit 1
    fi

    id -u hdfs &>/dev/null || useradd -m -u "$HDFS_UID" -g "$HDFS_GID" hdfs

    chown "$HDFS_UID:$HDFS_GID" "/home/hdfs"

    if [ ! -d /home/hdfs/.ssh ]; then
        cp -r /root/.ssh /home/hdfs/.ssh
        chown -R hdfs:hdfs /home/hdfs/.ssh
    fi

fi

exec /usr/sbin/sshd -D