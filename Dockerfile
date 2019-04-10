FROM resin/rpi-raspbian:latest
RUN apt-get install apt-transport-https
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN echo deb https://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ jessie main contrib non-free rpi >> /etc/apt/sources.list
RUN echo deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ jessie main ui >> /etc/apt/sources.list
RUN apt-get update && apt-get dist-upgrade && apt-get install wget -y
RUN wget -q https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh -O /tmp/raspapcommon.sh
RUN echo y | /bin/bash /tmp/raspapcommon.sh
EXPOSE 80 53

