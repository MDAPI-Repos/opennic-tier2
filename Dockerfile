FROM gitlab.mdapi.ch/mdapi/dependency_proxy/containers/debian:stable

ENV PACKAGES="\
  wget \
  bind9 \
  bind9-dnsutils \
  ca-certificates \
  cron \
  procps \
  systemd \
  iptraf-ng \
  less \
  iptables \
  iptables-persistent \
"\
  DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install -y --no-install-recommends $PACKAGES && apt clean all

COPY iptables.rules /etc/iptables/rules.v4

RUN systemctl enable cron named iptables

WORKDIR /etc/bind

COPY srvzone srvzone.conf ./
RUN ./srvzone -d

RUN mkdir -p /var/cache/bind/opennic/slave /var/cache/bind/opennic/master && chown -R bind:bind /var/cache/bind/opennic
RUN ./srvzone || true

RUN echo 'include "/etc/bind/named.conf.opennic";' >> named.conf
RUN truncate -s 0 named.conf.root-hints

RUN echo '20 * * * * root /etc/bind/srvzone' >> /etc/crontab

ENTRYPOINT ["/usr/lib/systemd/systemd"]
