FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./2worker.js /zmq/myworker.js
WORKDIR /zmq

CMD node myworker $BROKER_URL
