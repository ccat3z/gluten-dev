#! /bin/sh

set -e

KRB5_CONFIG_DIR=/etc/krb5
KRB5_KEYTAB=/etc/krb5/keytab

sed "s/__KDC_IP__/$(hostname -i)/g" /etc/krb5.conf.template > /etc/krb5.conf
cp /etc/krb5.conf "$KRB5_CONFIG_DIR/krb5.conf"

# Create the KDC database
kdb5_util create -r HADOOP.LOCAL -s -P qbnqxxLpMVK4WN4rv4hNMwfm

# Create keytab
rm -rf $KRB5_KEYTAB
kadmin.local -q "addprinc -randkey hdfs/localhost@HADOOP.LOCAL"
kadmin.local -q "ktadd -k $KRB5_KEYTAB hdfs/localhost@HADOOP.LOCAL"
chmod 666 $KRB5_KEYTAB

# Start kdc
exec krb5kdc -n