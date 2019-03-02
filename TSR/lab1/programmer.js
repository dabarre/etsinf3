const net = require('net')

let newAddress = process.argv[4]
let newPort = process.argv[5]
let proxyPort = process.argv[3]
let proxyAddress = process.argv[2]


let msg = JSON.stringify({'ip':newAddress, 'port':newPort})

let socket = net.connect({port:proxyPort, address:proxAddress}, 
        () => {
    socket.write(msg)
    socket.end()
})