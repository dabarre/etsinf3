//Event emitter
const ev = require('events');
const emitter = new ev.EventEmitter();
const e1 = "print", e2= "read";   // name of  events
var n1 = 0, n2 = 0;         // auxiliary vars

// register listener functionson the event emitter
emitter.on(e1,function() {
    console.log('event '+e1+' '+n1+++' times')
})
emitter.on(e2, function() {
    console.log('event '+e2+' '+n2+++' times')
})
emitter.on(e1,  // more than one listener for the same event is possible
    function() {
        console.log('something has been printed!')})

//The event generation and propagation are synchronous

emitter.emit(e1);
emitter.emit(e2);
console.log("----------------------------------------");

//The generation of events can be done asynchronous, for example,
//by means of setTimeout orsetInterval
// Generate the events periodically
setInterval(function() {emitter.emit(e1);}, // generates e1
2000); // every 2 seconds
setInterval(function() {emitter.emit(e2);}, // generates e2
8000);                          // every 8 seconds
console.log("\n\t===========> end of code: events become emitted periodically\n");