const net = require('net')

const LOCAL_PORT = 8000
const LOCAL_IP = '129.0.0.1'
const REMOTE_PORT = 80
const REMOTE_IP = '158.42.4.23'

const server = net.createServer((socket) => {
    const serviceSocket = new net.Socket()
    serviceSocket.connect(parseInt(REMOTE_PORT)), REMOTE_IP, () => {
        socket.on('data', (msg) => {
            serviceSocket.write(msg)
        })
    }
    serviceSocket.on('data', (msg) => {
        socket.write(msg)
    })
}).listen(LOCAL_PORT, LOCAL_IP)
console.log("TCP server accepting connection on port: " + LOCAL_PORT)