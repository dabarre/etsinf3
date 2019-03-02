const zmq = require('zmq')
const ansInterval = 2000
let who=[], req=[], workers=[], tout={}
let sc = zmq.socket('router') // frontend
let sw = zmq.socket('router') // backend
sc.bind('tcp://*:9998')
sw.bind('tcp://*:9999')

function resend(c,m) {
	return function() {
		sw.send([workers.shift(),'',c,'',m])
	}
}
function sendToW(w,c,m) {
	sw.send([w,'',c,'',m])
	tout[w]=setTimeout(resend(c,m), ansInterval)
}

sc.on('message',(c,sep,m)=> {
	if (workers.length==0) { 
		who.push(c); req.push(m)
	} else {
		sendToW(workers.shift(),c,m)
	}
})
sw.on('message',(w,sep,c,sep2,r)=> {
    if (c=='') {workers.push(w); return}
	clearTimeout(tout[w]); delete tout[w]
	if (who.length==0) { 
		workers.push(w)
	} else {
		sendToW(w,who.shift(),req.shift())
	}
	sc.send(c,'',r)
})