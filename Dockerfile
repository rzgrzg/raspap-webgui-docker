FROM raspbian/stretch:latest
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo deb http://mirrors.aliyun.com/raspbian/raspbian/ stretch main contrib non-free rpi >> /etc/apt/sources.list
RUN echo deb http://mirrors.aliyun.com/debian/ stretch main ui >> /etc/apt/raspi.list
#RUN apt-get update && apt-get install wget -y
#RUN apt-get update && apt-get install wget iproute iproute-doc -y
RUN wget -q https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh -O /tmp/raspapcommon.sh
#RUN echo y | /bin/bash /tmp/raspapcommon.sh
EXPOSE 80 53
#CMD ["echo y | /bin/bash /tmp/raspapcommon.sh"]
CMD sh -c '/bin/echo -e "y\ny\n" | sh Anaconda3-4.4.0-Linux-x86_64.sh'
