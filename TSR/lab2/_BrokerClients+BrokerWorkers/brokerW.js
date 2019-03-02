const zmq = require('zmq')
let workers=[]
let sbc = zmq.socket('router') // backend
let sw = zmq.socket('router') // brokerC
sbc.bindSync('tcp://*:9998')
sw.bind('tcp://*:9999')
console.log('brokerW inciado')
let brokerID
//foward requeset
sbc.on('message',(id,c,sep2,m)=> {
	if (c=='') {
		brokerID = id+''
	} else {
		console.log('mandando request')
		sw.send([workers.shift(),'',c,'',m])
	}
})
//if '' add new worker
//	then inform bc
//else foward answer
sw.on('message',(w,sep,c,sep2,r)=> {
	if (c=='') {
		console.log('worker añadido')
		workers.push(w)
		sbc.send([brokerID,'','',r])
	} else {
		console.log('mandando respuesta')
		let newR = w + ' ' + r
		workers.push(w)
		sbc.send([brokerID,c,'',newR])		
	}
})