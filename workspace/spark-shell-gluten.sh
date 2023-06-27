#! /bin/sh

set -ex

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
REPO_DIR=$(realpath "$SCRIPT_DIR/..")

SPARK_HOME="${SCRIPT_DIR}/spark-332"
GLUTEN_JAR="${SCRIPT_DIR}/gluten-velox-bundle-spark3.3_2.12-centos_7-0.5.0-SNAPSHOT.jar"

if [ ! -f "$GLUTEN_JAR" ]; then
    echo "Gluten jar not found ($GLUTEN_JAR)" >&2
    exit 1
fi

SPARK_FLAGS=
SPARK_FILES=

# Common
SPARK_FLAGS="$SPARK_FLAGS \
  --conf spark.driver.extraJavaOptions=-Dderby.system.home=$SCRIPT_DIR/derby \
  --conf spark.network.timeout=200000 \
  --conf spark.executor.heartbeatInterval=100000
"

# Enable gluten
USE_GLUTEN=yes
if [ "$USE_GLUTEN" = "yes" ]; then
  SPARK_FLAGS="$SPARK_FLAGS \
    --conf spark.driver.extraClassPath=$GLUTEN_JAR \
    --conf spark.executor.extraClassPath=./$(basename "$GLUTEN_JAR") \
    --conf spark.plugins=io.glutenproject.GlutenPlugin \
    --conf spark.gluten.sql.columnar.backend.lib=velox \
    --conf spark.shuffle.manager=org.apache.spark.shuffle.sort.ColumnarShuffleManager \
    --conf spark.memory.offHeap.enabled=true \
    --conf spark.memory.offHeap.size=10G \
  "
  SPARK_FILES="$SPARK_FILES,$GLUTEN_JAR"
fi

# libhdfs3 config
SPARK_FLAGS="$SPARK_FLAGS --conf spark.executorEnv.LIBHDFS3_CONF=hdfs-client.xml"
SPARK_FILES="$SPARK_FILES,$SCRIPT_DIR/hdfs-client.xml"

# Yarn
USE_YARN=yes
if [ "$USE_YARN" = "yes" ]; then
  rm -f "/tmp/krb5cc_$(id -u)"
  SPARK_FLAGS="$SPARK_FLAGS \
    --master yarn \
    --keytab /etc/krb5/keytab \
    --principal hdfs/localhost@HADOOP.LOCAL \
    --conf spark.driver.userClassPathFirst=true \
    --conf spark.executor.userClassPathFirst=true \
  "
else
  kinit -kt /etc/krb5/keytab hdfs/localhost@HADOOP.LOCAL
fi

cd "$SCRIPT_DIR"
mkdir -p /tmp/spark-events
# shellcheck disable=SC2086
exec "$SPARK_HOME/bin/spark-shell" $SPARK_FLAGS --files ${SPARK_FILES#,}
