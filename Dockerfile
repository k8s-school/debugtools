FROM alpine:3.20

RUN apk add --update-cache \
    bash \
    fio \
    iotop \
    sysstat \
    strace \
    net-tools \
    vim \
  && rm -rf /var/cache/apk/*

# Set default command
CMD ["/usr/bin/bash"]
