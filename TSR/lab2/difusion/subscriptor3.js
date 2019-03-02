const zmq = require('zmq')
let sub = zmq.socket('sub')
sub.connect('tcp://127.0.0.1:9999')
sub.subscribe('tres') 
sub.on('message', (...m) => 
	{console.log('3',m)})
