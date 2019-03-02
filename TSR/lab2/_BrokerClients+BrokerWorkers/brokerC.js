const zmq = require('zmq')
let cli=[], req=[]
let sc = zmq.socket('router') // frontend
let sbw = zmq.socket('dealer') // brokerW
sc.bind('tcp://*:9997')
let id = 'brokerC'
sbw.identity = id
sbw.connect('tcp://localhost:9998')
let aw = 0
console.log('brokerC inciado')

//if no workers available queue
//else request
sbw.send(['','',''])
sc.on('message',(c,sep,m)=> {
	if (aw==0) {
		console.log('client a la cola')
		cli.push(c); req.push(m)
	} else {
		console.log('mandando request')
		sbw.send([c,'',m])
		aw--
	}
})
//if '' add new worker
//	then try to work
//else foward answer
sbw.on('message',(c,sep2,r)=> {
	if (c=='') {
		console.log('worker disponible')
		aw++
		if (cli.length>0) {
			console.log('mandando request')
			sbw.send([cli.shift(),'', req.shift()])
			aw--
		}
	} else {
		console.log('mandando respuesta')
		sc.send([c,'',r])
		aw++
	}
})