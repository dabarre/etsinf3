const Evento = require('./generadorEventos')

const e1 = 'e1'
const e2 = 'e2'
var incremento = 0

const emisor1 = Evento(e1, 'emisor1: ', incremento)
const emisor2 = Evento(e2, 'emisor2: ', incremento)

function visualizar(entidad, evento, dato) {
    console.log(entidad, evento + '-->', dato)
}

emisor1.on(visualizar)
emisor2.on(visualizar)

emisiones()

function emisiones() {
    time = Math.floor((Math.random() * 4) + 2)*1000;
    setInterval(() => {
        emisor1.emit(1)
        emisor2.emit(1)
        console.log(time/1000 + ' seconds')
    }, time)
}