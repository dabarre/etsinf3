const zmq = require('zmq')
let cli=[], req=[], workers=[]
let sc = zmq.socket('router') // frontend
let sw = zmq.socket('router') // backend

let portFrontEnd = process.argv[2]
let portBackend = process.argv[3]
let countRH = 0 //extra
let ws = {} //extra

sc.bind('tcp://*:' + portFrontEnd)
sw.bind('tcp://*:' + portBackend)
sc.on('message',(c,sep,m)=> {
	if (workers.length==0) { 
		cli.push(c); req.push(m)
		console.log('Me pongo a la cola')
	} else {
		let w = workers.shift()
		sw.send([w,'',c,'',m])
		console.log('handle request')
		countRH++  //extra
		ws[w]++
	}
})
sw.on('message',(w,sep,c,sep2,r)=> {
    if (c=='') {
		console.log('\nSe añade un worker')  //extra
		workers.push(w)
		ws[w] = 0
		return
	}
	if (cli.length>0) {		
		sw.send([w,'',cli.shift(),'',req.shift()])
		console.log('handle request')
		countRH++;  //extra
		ws[w]++
	} else {
		workers.push(w)
		console.log('Worker a la cola')
	}
	sc.send([c,'',r])
	
})
//extra
let interval = setInterval(() => {
	console.log('\nTotal no. of requests handled: ' + countRH)
	for (let w in ws) {
		console.log(w + ': ' + ws[w])
	}
}, 5000)
setTimeout(() => {
	clearInterval(interval)
	process.exit(0)
}, 20000)