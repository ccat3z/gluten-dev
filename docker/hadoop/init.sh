#! /bin/sh

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/sbin/sshd-keygen
fi

exec /usr/sbin/sshd -D