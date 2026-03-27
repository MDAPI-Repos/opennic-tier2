FROM gitlab.mdapi.ch/mdapi/dependency_proxy/containers/debian:stable

ENV PACKAGES="\
  wget \
  bind9 \
  bind9-dnsutils \
  ca-certificates \
  cron \
  dialog \
  procps \
"

RUN apt update
RUN apt install -y --no-install-recommends $PACKAGES

WORKDIR /root
COPY . .
RUN ./srvzone -d
