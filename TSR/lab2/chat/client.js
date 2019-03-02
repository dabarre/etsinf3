const zmq = require('zmq')
const nick='Ana'
let sub = zmq.socket('sub') 
let psh = zmq.socket('push')
sub.connect('tcp://127.0.0.1:9998')
psh.connect('tcp://127.0.0.1:9999')
sub.subscribe('')
sub.on('message', (nick,m) => {
	console.log('['+nick+']'+m)
})
process.stdin.resume()
process.stdin.setEncoding('utf8')
process.stdin.on('data'  ,(str)=> {
	psh.send([nick, str.slice(0,-1)])
})
process.stdin.on('end',()=> {
	psh.send([nick, 'BYE'])
})
process.on('SIGINT',()=> {
	sub.close(); psh.close()
})
psh.send([nick,'HI'])