const zmq = require('zmq')
let req = zmq.socket('req')
let workerID =process.argv[2]
req.identity = workerID
req.connect('tcp://localhost:9999')
req.on('message', (c,sep,msg)=> {
	setTimeout(()=> {
		req.send([c,'','responded'])
		console.log(workerID + ' mandando respuesta')
	}, 1000)
})
req.send(['','',''])