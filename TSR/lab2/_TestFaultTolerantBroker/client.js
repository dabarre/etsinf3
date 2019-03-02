const zmq = require('zmq')
let req = zmq.socket('req');
req.connect('tcp://localhost:9998')

let nickClient = process.argv[2]
req.identity = nickClient

req.on('message', (msg)=> {
	console.log('\n' + nickClient + ' resp: '+msg)
	process.exit(0);
})
req.send('Hola')