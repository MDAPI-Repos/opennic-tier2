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

WORKDIR /root
COPY . .
RUN ./srvzone -d

ENTRYPOINT ["/sbin/init"]
CMD ["systemctl"]
