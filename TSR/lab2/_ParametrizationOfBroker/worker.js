const zmq = require('zmq')
let req = zmq.socket('req')

let urlBackend = process.argv[2]
let nickWorker = process.argv[3]
let txtRespuesta = process.argv[4]

req.identity = nickWorker
req.connect(urlBackend)
req.on('message', (c,sep,msg)=> {
	setTimeout(()=> {
		req.send([c,'', txtRespuesta])
	}, 1000)
})
req.send(['','',''])
setTimeout(() => {
	process.exit(0)
}, 15000)