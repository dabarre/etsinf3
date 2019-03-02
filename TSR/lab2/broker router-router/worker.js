const zmq = require('zmq')
let req = zmq.socket('req')
req.identity('Worker1')
req.connect('tcp://localhost:9999')
req.on('message', (c,sep,msg)=> {
	setTimeout(()=> {
		rep.send([c,'','resp'])
	}, 1000)
})
req.send(['','',''])