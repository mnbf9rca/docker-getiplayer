FROM phusion/baseimage:0.9.18

MAINTAINER mnbf9rca

VOLUME ["/content", "/tmp", "/cache"]

EXPOSE 80

RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y \
software-properties-common \
python-software-properties && \
add-apt-repository -y ppa:jon-hedgerows/get-iplayer && \
apt-get update && \
apt-get install -y \
wget \
apache2 \
get-iplayer \
rtmpdump
