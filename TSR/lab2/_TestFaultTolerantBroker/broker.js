const zmq = require('zmq')
let cli=[], req=[], workers=[]
let sc = zmq.socket('router') // frontend
let sw = zmq.socket('router') // backend
sc.bind('tcp://*:9998')
sw.bind('tcp://*:9999')
let countR = 0
let countW = 0
sc.on('message',(c,sep,m)=> {
	if (workers.length==0) {
		//si no hay workers hace cola y se guarda la request
		cli.push(c); req.push(m)
	} else {
		//si hay workers se envia la petición
		sw.send([workers.shift(),'',c,'',m])
		countR++
	}
})
sw.on('message',(w,sep,c,sep2,r)=> {
	//cuando el worker se inicia se pone en la cola esperando un request
	if (c=='') {workers.push(w); countW++; return}
	//si hay clientes le da directamente trabajo
	if (cli.length>0) { 
		sw.send([w,'', cli.shift(),'', req.shift()])
		countR++
	} else {
		//si no hay clientes espera en la cola
		workers.push(w)
	}
	let newR = r + ' ' +  w
	sc.send([c,'',newR])
	countW--
})

//extra
let interval = setInterval(() => {
	console.log('\nTotal no. of requests handled: ' + countR)
	console.log('\nTotal no. of pending requests: ' + countW)
}, 800)
setTimeout(() => {
	clearInterval(interval)
	process.exit(0)
}, 20000)

