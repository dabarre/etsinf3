FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./logger.js /zmq/mylogger.js
WORKDIR /zmq
VOLUME /tmp/cbwlog
EXPOSE 9995
CMD node mylogger 9995 $LOGGER_DIR/logs
