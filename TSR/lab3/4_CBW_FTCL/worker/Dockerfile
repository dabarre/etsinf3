FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./worker.js /zmq/myworker.js
WORKDIR /zmq
# We assume that each worker is linked to the broker
# container.
CMD node myworker $BROKER_URL $CLASSID
