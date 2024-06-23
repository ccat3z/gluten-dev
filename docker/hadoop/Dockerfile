FROM centos:7

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf 

RUN yum -y install \
        java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Kerberos
RUN yum -y install \
        krb5-workstation krb5-libs

# ssh
RUN yum -y install openssh-server openssh-clients

# sudo
RUN yum -y install sudo
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# jsvc
RUN yum -y install apache-commons-daemon-jsvc

# hadoop
ENV HADOOP_VERSION=3.4.0
RUN curl -L https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar -zx -f- -C /opt \
    && mv /opt/hadoop-$HADOOP_VERSION /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$HADOOP_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

COPY init.sh /init.sh
COPY ssh /root/.ssh
COPY limits-nproc.conf /etc/security/limits.d/20-nproc.conf
RUN ln -sf /etc/krb5/krb5.conf /etc/krb5.conf

CMD /init.sh