FROM resin/rpi-raspbian
RUN apt-get update && apt-get install wget bash -y 
RUN wget -q https://git.io/voEUQ -O /tmp/raspap 
EXPOSE 80 53
CMD ["bash /tmp/raspap"]
