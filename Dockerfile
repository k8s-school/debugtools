FROM centos:centos7

# Reinstall all packages to get man pages for them
RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true
RUN yum -y reinstall "*" && yum clean all

# Install all useful packages
RUN yum -y install \
           bash-completion \
           bc \
           blktrace \
           ethtool \
           file \
           findutils \
           gcc \
           gdb \
           git \
           iotop \
           iproute \
           iputils \
           less \
           ltrace \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           procps-ng \
           psmisc \
           rootfiles \
           screen \
           strace \
           sysstat \
           tar \
           tcpdump \
           vim-enhanced \
           vim-minimal \
           which \
           yum-utils \
           && yum clean all

ADD debugtools /usr/bin

# Set default command
CMD ["/usr/bin/bash"]
