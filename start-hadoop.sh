#!/bin/bash

# Khởi động SSH
service ssh start

# Định dạng HDFS (Chỉ chạy lần đầu, cần kiểm tra trước khi chạy)
if [ ! -d "/tmp/hadoop-root/dfs/name" ]; then
    hdfs namenode -format
fi

# Start hadoop
start-dfs.sh 
start-yarn.sh

# Giữ container chạy
tail -f /dev/null