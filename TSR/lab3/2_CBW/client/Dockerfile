FROM tsr1718/centos-zmq
RUN mkdir /zmq
COPY ./2client.js /zmq/myclient.js
WORKDIR /zmq

CMD node myclient $BROKER_URL
