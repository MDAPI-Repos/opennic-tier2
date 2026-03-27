FROM gitlab.mdapi.ch/mdapi/dependency_proxy/containers/debian:stable

ENV PACKAGES="\
  wget \
  bind9 \
  bind9-dnsutils \
  ca-certificates \
  cron \
  dialog \
  procps \
  systemctl \
  init \
  iptraf-ng \
"

RUN apt update -y && apt install -y --no-install-recommends $PACKAGES && apt clean all

RUN systemctl enable cron named

WORKDIR /etc/bind

COPY srvzone srvzone.conf ./
RUN ./srvzone -d

RUN echo 'include "/etc/bind/named.conf.opennic";' >> named.conf
RUN truncate -s 0 named.conf.root-hints

RUN echo '20 * * * * root /etc/bind/srvzone' >> /etc/crontab

ENTRYPOINT ["/sbin/init"]
