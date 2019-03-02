const zmq = require('zmq');
const pub = zmq.socket('pub');

let port = process.argv[2];
let numMessages = process.argv[3];
let topics = process.argv.slice(4);
let tCount = new Array(topics.length);
tCount.fill(1);

pub.bind('tcp://*:' + port);

let count = 0;
setInterval(() => {
    if (numMessages == count) {
        pub.close();
        process.exit();
    }
    let pos = count%topics.length;
    pub.send(++count + ': ' + topics[pos] + ' ' + tCount[pos]++);

}, 1000);
