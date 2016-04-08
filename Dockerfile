FROM ubuntu:14.04
MAINTAINER dharmik


# install xvfb and other X dependencies for IB
RUN apt-get update -y \
    && apt-get install -y xvfb libxrender1 libxtst6 x11vnc socat \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN mkdir /ib-gateway
WORKDIR /ib-gateway

# download and install the IB-gateway
#RUN wget https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh && \
#    chmod +x ibgateway-latest-standalone-linux-x64.sh && \
#    echo "n" | ./ibgateway-latest-standalone-linux-x64.sh && \
#    mv /root/Jts/ibgateway/955/jars /ib-gateway

#ADD jts4launch.jar jts4launch.jar
#ADD log4j-1.2.17.jar log4j-1.2.17.jar
#ADD total.jar total.jar
#ADD twslaunch.jar twslaunch.jar
#ADD twslaunch-install4j-1.5.jar twslaunch-install4j-1.5.jar
# install init scripts and binaries

RUN wget -O total.jar -q https://download2.interactivebrokers.com/java/classes/total.2015.jar \
    && wget -O jts.jar -q https://download2.interactivebrokers.com/java/classes/latest/jts.latest.jar


ADD config/jts.ini /ib-gateway/jts.ini
ADD init/xvfb_init /etc/init.d/xvfb
ADD init/vnc_init /etc/init.d/vnc
ADD bin/xvfb-daemon-run /usr/bin/xvfb-daemon-run
ADD bin/run-gateway /usr/bin/run-gateway

# vnc (optional)
# set your own password to launch vnc
# ENV VNC_PASSWORD doughnuts

# 5900 for VNC, 4003 for the gateway API via socat
EXPOSE 5900 4003
VOLUME /ib-gateway

ENV DISPLAY :0

CMD ["/usr/bin/run-gateway"]
