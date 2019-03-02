node broker.js 8000 8001 &
node worker.js tcp://localhost:8001 W1 Resp1 &
node worker.js tcp://localhost:8001 W2 Resp2 &
node client.js tcp://localhost:8000 C1 Hello &
node client.js tcp://localhost:8000 C2 Hola &
node client.js tcp://localhost:8000 C3 Hi &
