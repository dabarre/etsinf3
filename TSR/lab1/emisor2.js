//Emisor de eventos
const Evento=require("./generadorEventos");
function visualizar(entidad,evento,dato){
    console.log(entidad,evento+'··> ',dato);
}
const evento1 = 'e1';
const evento2 = 'e2';
const emisor1 = Evento(evento1,'emisor1:   ',0);
const emisor2 = Evento(evento2,'emisor2:   ','');
emisor1.on(visualizar);
emisor2.on(visualizar);
console.log('\n\n------->> inicial\n\n');
for(var i=1;i<=3;i++) emisor1.emit(i);
    console.log('\n\n------------------>> intermedio\n\n');
for(var i=1;i<=3;i++) emisor2.emit(i);
    console.log('\n\n-------------------------------->> fin\n\n')