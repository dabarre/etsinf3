FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./2client.js /zmq/myclient.js
WORKDIR /zmq

CMD node myclient NEED_BROKER_URL
