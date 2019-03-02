const zmq = require('zmq')
let req = zmq.socket('req');
let nickClient = process.argv[2]
req.identity = nickClient
req.connect('tcp://localhost:9997')

req.on('message', (msg)=> {
	console.log('\n' + nickClient + ' resp: '+msg)
	process.exit(0);
})
req.send('Hey!')