export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
export SPARK_HOME=/opt/spark
export SPARK_DIST_CLASSPATH=/opt/hadoop/share/hadoop/common/lib/*
export SPARK_MASTER=spark://spark-master:7077
export SPARK_WORKER_MEMORY=1g
export SPARK_EXECUTOR_MEMORY=1g
export SPARK_WORKER_CORES=1
export SPARK_EXECUTOR_CORES=1
export SPARK_LOCAL_DIRS=/mnt/spark-temp
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

