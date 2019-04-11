FROM raspbian/stretch:latest
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo deb http://mirrors.aliyun.com/raspbian/raspbian/ stretch main contrib non-free rpi >> /etc/apt/sources.list
RUN echo deb http://mirrors.aliyun.com/debian/ stretch main ui >> /etc/apt/raspi.list
RUN apt-get update && apt-get install git lighttpd php7.0-cgi hostapd dnsmasq vnstat -y
RUN lighttpd-enable-mod fastcgi-php && service lighttpd restart
RUN rm -rf /var/www/html && git clone https://github.com/billz/raspap-webgui /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN mkdir /etc/raspap && mv /var/www/html/raspap.php /etc/raspap/ && chown -R www-data:www-data /etc/raspap

RUN mkdir /etc/raspap/hostapd && mv /var/www/html/installers/*log.sh /etc/raspap/hostapd 
RUN echo 'echo 1 > /proc/sys/net/ipv4/ip_forward #RASPAP'>>/etc/rc.local
RUN echo 'iptables -t nat -A POSTROUTING -j MASQUERADE #RASPAP '>>/etc/rc.local
RUN echo 'iptables -t nat -A POSTROUTING -s 192.168.50.0/24 ! -d 192.168.50.0/24 -j MASQUERADE #RASPAP'
RUN systemctl enable hostapd.service
EXPOSE 80 53
CMD ["/bin/bash"]
