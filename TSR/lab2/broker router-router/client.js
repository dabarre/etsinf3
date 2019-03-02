const zmq = require('zmq')
let req = zmq.socket('req');
req.connect('tcp://localhost:9998')
req.on('message', (msg)=> {
	console.log('resp: '+msg)
	process.exit(0);
})
requester.send('Hola')