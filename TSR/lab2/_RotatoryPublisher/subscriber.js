const zmq = require('zmq');
const sub = zmq.socket('sub');
sub.connect('tcp://127.0.0.1:' + process.argv.slice(2));
sub.subscribe('');
sub.on('message', (msg) => {
    console.log(msg.toString());
});