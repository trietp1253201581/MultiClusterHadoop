FROM ubuntu:22.04

# Cài đặt các gói cần thiết
RUN apt update && apt install -y \
    openjdk-8-jdk \
    openssh-server \
    wget \
    curl \
    nano \
    rsync \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip

# Tạo user mới và thiết lập quyền
RUN useradd -m -s /bin/bash hadoopuser && \
    echo "hadoopuser:hadoop" | chpasswd && \
    usermod -aG sudo hadoopuser

# Cấu hình SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "hadoopuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    sed -i 's/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config

# Cài đặt Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xvzf hadoop-3.3.6.tar.gz -C /opt && \
    mv /opt/hadoop-3.3.6 /opt/hadoop && \
    rm hadoop-3.3.6.tar.gz

# Thiết lập biến môi trường
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# Chuyển quyền thư mục Hadoop cho user mới
RUN chown -R hadoopuser:hadoopuser /opt/hadoop

# Tạo thư mục lưu dữ liệu cho NameNode và DataNode
RUN mkdir -p /home/hadoopuser/hadoop_data/hdfs/namenode && \
    mkdir -p /home/hadoopuser/hadoop_data/hdfs/datanode && \
    chown -R hadoopuser:hadoopuser /home/hadoopuser/hadoop_data && \
    chmod -R 755 /home/hadoopuser/hadoop_data

# Chuyển sang user hadoopuser để thiết lập SSH
USER hadoopuser

# Tạo SSH key và tắt kiểm tra host key để tránh lỗi SSH
RUN ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    echo "StrictHostKeyChecking no" >> ~/.ssh/config

# Quay lại user root để khởi động SSH khi container start
USER root
WORKDIR /home/hadoopuser

# Khởi động SSH khi container chạy
CMD ["/bin/bash", "-c", "service ssh start; tail -f /dev/null"]
