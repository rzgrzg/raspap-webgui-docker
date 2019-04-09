FROM resin/rpi-raspbian
RUN apt-get update && apt-get install wget -y 
RUN wget -q https://git.io/voEUQ -O /tmp/raspap && bash /tmp/raspap
EXPOSE 80 53
CMD ["/tmp/raspap"]
