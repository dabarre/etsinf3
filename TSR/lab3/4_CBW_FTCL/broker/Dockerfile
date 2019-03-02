FROM tsr1718/centos-zmq
RUN mkdir /zmq
#COPY ./ftbroker_class_log-funciona.js /zmq/mybroker.js
COPY ./ftbroker_class_log.js /zmq/mybroker.js
WORKDIR /zmq
EXPOSE 9998 9999
CMD node mybroker 9998 9999 $LOGGER_URL
