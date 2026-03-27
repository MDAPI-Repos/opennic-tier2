FROM gitlab.mdapi.ch/mdapi/dependency_proxy/containers/debian:stable

ENV PACKAGES="\
  wget \
  bind9 \
"

RUN apt update
RUN apt install -y --no-install-recommends $PACKAGES

WORKDIR /root
COPY . .
RUN ./srvzone -d

CMD ["sleep", "infinity"]
