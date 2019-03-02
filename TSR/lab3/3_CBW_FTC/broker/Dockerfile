FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./ftbroker_class.js /zmq/mybroker.js
WORKDIR /zmq
EXPOSE 9998 9999
CMD node mybroker 9998 9999
