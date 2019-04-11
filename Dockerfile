FROM raspbian/stretch:latest
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo deb http://mirrors.aliyun.com/raspbian/raspbian/ stretch main contrib non-free rpi >> /etc/apt/sources.list
RUN echo deb http://mirrors.aliyun.com/debian/ stretch main ui >> /etc/apt/raspi.list
RUN apt-get update && apt-get install git lighttpd php7.0-cgi hostapd dnsmasq vnstat -y
RUN lighttpd-enable-mod fastcgi-php && service lighttpd restart

RUN { \
echo www-data ALL=(ALL) NOPASSWD:/sbin/ifdown\
echo www-data ALL=(ALL) NOPASSWD:/sbin/ifup\
echo www-data ALL=(ALL) NOPASSWD:/bin/cat /etc/wpa_supplicant/wpa_supplicant.conf\
echo www-data ALL=(ALL) NOPASSWD:/bin/cat /etc/wpa_supplicant/wpa_supplicant-wlan[0-9].conf\
echo www-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/wifidata /etc/wpa_supplicant/wpa_supplicant.conf\
echo www-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/wifidata /etc/wpa_supplicant/wpa_supplicant-wlan[0-9].conf\
echo www-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli -i wlan[0-9] scan_results\
echo www-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli -i wlan[0-9] scan\
echo www-data ALL=(ALL) NOPASSWD:/sbin/wpa_cli -i wlan[0-9] reconfigure\
echo www-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/hostapddata /etc/hostapd/hostapd.conf\
echo www-data ALL=(ALL) NOPASSWD:/etc/init.d/hostapd start\
echo www-data ALL=(ALL) NOPASSWD:/etc/init.d/hostapd stop\
echo www-data ALL=(ALL) NOPASSWD:/etc/init.d/dnsmasq start\
echo www-data ALL=(ALL) NOPASSWD:/etc/init.d/dnsmasq stop\
echo www-data ALL=(ALL) NOPASSWD:/bin/cp /tmp/dhcpddata /etc/dnsmasq.conf\
echo www-data ALL=(ALL) NOPASSWD:/sbin/shutdown -h now\
echo www-data ALL=(ALL) NOPASSWD:/sbin/reboot\
echo www-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan[0-9] down\
echo www-data ALL=(ALL) NOPASSWD:/sbin/ip link set wlan[0-9] up\
echo www-data ALL=(ALL) NOPASSWD:/sbin/ip -s a f label wlan[0-9]\
echo www-data ALL=(ALL) NOPASSWD:/bin/cp /etc/raspap/networking/dhcpcd.conf /etc/dhcpcd.conf\
echo www-data ALL=(ALL) NOPASSWD:/etc/raspap/hostapd/enablelog.sh\
echo www-data ALL=(ALL) NOPASSWD:/etc/raspap/hostapd/disablelog.sh\
echo www-data ALL=(ALL) NOPASSWD:/etc/raspap/hostapd/servicestart.sh\
} | tee -a /etc/sudoers 

RUN rm -rf /var/www/html && git clone https://github.com/billz/raspap-webgui /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN mkdir /etc/raspap && mv /var/www/html/raspap.php /etc/raspap/ && chown -R www-data:www-data /etc/raspap

RUN mkdir /etc/raspap/hostapd && mv /var/www/html/installers/*log.sh /etc/raspap/hostapd 
RUN echo 'echo 1 > /proc/sys/net/ipv4/ip_forward #RASPAP'>>/etc/rc.local
RUN echo 'iptables -t nat -A POSTROUTING -j MASQUERADE #RASPAP '>>/etc/rc.local
RUN echo 'iptables -t nat -A POSTROUTING -s 192.168.50.0/24 ! -d 192.168.50.0/24 -j MASQUERADE #RASPAP'

#RUN systemctl restart rc-local.service
#RUN systemctl daemon-reload

RUN systemctl unmask hostapd.service
RUN systemctl enable hostapd.service
EXPOSE 80 53
CMD ["/bin/bash"]
