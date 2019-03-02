const zmq = require('zmq')
let s = zmq.socket('rep')
s.bind('tcp://*:9998')
s.on('message', (n) => {
    console.log('Serv1, '+n)
    switch (n) {
        case 'uno': s.send('one')
        case 'dos': s.send('two')
        default: s.send('mmmmm.. no se')
    }
})