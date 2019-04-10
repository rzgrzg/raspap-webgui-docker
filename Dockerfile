FROM resin/rpi-raspbian
ENV UPDATE_URL https://raw.githubusercontent.com/billz/raspap-webgui/master/
RUN apt-get update && apt-get install wget lighttpd $php_package git hostapd dnsmasq vnstat -y 
RUN wget -q ${UPDATE_URL}/installers/common.sh -O /tmp/raspapcommon.sh
EXPOSE 80 53
CMD ["bash /tmp/raspapcommon.sh"]
