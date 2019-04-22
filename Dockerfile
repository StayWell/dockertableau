
FROM centos/systemd

MAINTAINER "Babajide Hassan" <bhassan@staywell.com>


ENV TABLEAU_VERSION="2019.1.2" \
    LANG=en_US.UTF-8

VOLUME /sys/fs/cgroup /run /tmp

COPY config/lscpu /bin

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y iproute curl sudo vim && \
    adduser tsm && \
    (echo tsm:tsm | chpasswd) && \
    (echo 'tsm ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tsm) && \
    mkdir -p  /run/systemd/system /opt/tableau/docker_build && \
    yum install -y \
             "https://downloads.tableau.com/esdalt/2019.1.1/tableau-server-2019-1-1.x86_64.rpm" \
             "https://s3.amazonaws.com/redshift-downloads/drivers/odbc/1.4.4.1001/AmazonRedshiftODBC-64-bit-1.4.4.1001-1.x86_64.rpm"\
             "https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.12-1.el6.x86_64.rpm"\
             "https://downloads.tableau.com/drivers/linux/yum/tableau-driver/tableau-postgresql-odbc-9.5.3-1.x86_64.rpm"  && \
    rm -rf /var/tmp/yum-* 


COPY config/* /opt/tableau/docker_build/

RUN mkdir -p /etc/systemd/system/ && \
    cp /opt/tableau/docker_build/tableau_server_install.service /etc/systemd/system/ && \
    systemctl enable tableau_server_install 

EXPOSE 80 8850

CMD /sbin/init