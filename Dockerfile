FROM resin/rpi-raspbian:latest
RUN apt-get update && apt-get dist-upgrade && apt-get install wget -y
RUN wget -q https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh -O /tmp/raspapcommon.sh
RUN echo y | /bin/bash /tmp/raspapcommon.sh
EXPOSE 80 53

