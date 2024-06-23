#! /bin/bash

set -ex


export HADOOP_HOME=/opt/hadoop

sudo chown -R "$(id -u):$(id -g)" /var/lib/hadoop/ha-name-dir-shared
for i in 1 3; do
    ssh gluten-hadoop-$i $HADOOP_HOME/bin/hdfs namenode -format -clusterId test
    ssh gluten-hadoop-$i $HADOOP_HOME/bin/hdfs --daemon start namenode
done

for i in 2 4; do
    ssh gluten-hadoop-$i $HADOOP_HOME/bin/hdfs namenode -bootstrapStandby
done

for i in 1 3; do
    ssh gluten-hadoop-$i $HADOOP_HOME/bin/hdfs --daemon stop namenode
done

for i in 1 3; do
    ssh gluten-hadoop-$i sudo $HADOOP_HOME/bin/hdfs zkfc -formatZK
done

sudo $HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

for i in {1..6}; do
    ssh gluten-hadoop-$i $HADOOP_HOME/bin/hdfs --daemon start dfsrouter
done