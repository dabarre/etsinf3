const zmq = require('zmq')
let req = zmq.socket('req')
req.identity = process.argv[2]
req.connect('tcp://localhost:9999')
req.on('message', (c,sep,msg)=> {
	setTimeout(()=> {
		req.send([c,'','resp'])
	}, 1000)
})
req.send(['','',''])