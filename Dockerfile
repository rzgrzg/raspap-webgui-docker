FROM resin/rpi-raspbian
ENV UPDATE_URL https://raw.githubusercontent.com/billz/raspap-webgui/master/
RUN apt-get update && apt-get install wget git lighttpd php7.0-cgi hostapd dnsmasq vnstat
RUN wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/raspapcommon.sh
EXPOSE 80 53
CMD ["/bin/bash"]
