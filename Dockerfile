FROM resin/rpi-raspbian
RUN apt-get update && apt-get install wget git lighttpd php5-cgi hostapd dnsmasq vnstat
RUN wget -q https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh -O /tmp/raspapcommon.sh
EXPOSE 80 53
CMD ["/bin/bash /tmp/raspapcommon.sh"]
