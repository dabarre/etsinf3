/****MUSIC****/

--Queries using one single relation
--1)
select COUNT(*)
from BDA.DISCO;

--2)
select nombre
from BDA.GRUPO
where pais <> 'Espa�a';

--3)
select TITULO
from BDA.CANCION
where DURACION > 5;

--4)
select DISTINCT funcion
from BDA.PERTENECE;

--5)
select nombre, NUM
from BDA.CLUB
order by NUM;

--6)
select nombre, sede
from BDA.CLUB
where num > 500;

--Queries using more than one relation
--7)
select C.nombre, C.sede, G.nombre
from BDA.CLUB C, BDA.GRUPO G
where C.cod_gru = G.cod AND G.pais = 'Espa�a';

--8)
select A.nombre
from BDA.ARTISTA A, BDA.PERTENECE P, BDA.GRUPO G
where A.dni = P.dni AND P.cod = G.cod AND G.pais='Espa�a';

--9)
select D.nombre
from BDA.CANCION S, BDA.ESTA E, BDA.DISCO D
where S.duracion > 5 AND S.cod = E.can AND E.cod = D.cod;

--10)
select S.titulo
from BDA.CANCION S, BDA.ESTA E, BDA.DISCO D
where S.titulo = D.nombre AND S.cod = E.can AND E.cod = D.cod;

--11)
select C.nombre, C.dir
from BDA.COMPANYIA C, BDA.DISCO D
where D.nombre LIKE 'A%' AND C.cod = D.cod_comp;

--12)
select DISTINCT P1.dni
from BDA.PERTENECE P1, BDA.PERTENECE P2
where P1.dni = P2.dni AND P1.cod <> P2.cod;

--Queries using subqueries
--13)
select D.nombre
from BDA.DISCO D, BDA.GRUPO G
where D.cod_gru = G.cod AND G.fecha = (select MIN(GG.fecha) from BDA.GRUPO GG);

--14)
select D.nombre
from BDA.DISCO D, BDA.GRUPO G
where D.cod_gru = G.cod AND G.cod IN
    (select C.cod_gru
    from BDA.CLUB C
    where C.num > 5000);

--15)
select C.nombre, C.num
from BDA.CLUB C
where C.num = (select MAX(C2.num) from BDA.CLUB C2);

--16)
select C.titulo, C.duracion
from BDA.CANCION C
where C.duracion = (select MAX(C2.duracion) from BDA.CANCION C2);

--Queries with universal quantification
--17)
select C.nombre
from COMPANYIA C
where C.cod NOT IN (
    select D.cod_comp
    from DISCO D
    where D.cod_gru IN
        (select G.cod
        from GRUPO G
        where G.pais = 'Espa�a'));

--18)
select C.nombre
from COMPANYIA C
where C.cod IN (
    select D.cod_comp
    from DISCO D
    where D.cod_gru IN
        (select G.cod
        from GRUPO G
        where G.pais = 'Espa�a'));

--19)
select DISTINCT C.nombre, C.dir
from COMPANYIA C, DISCO D
where C.cod = D.cod_comp AND NOT EXISTS
    (select *
    from DISCO D2
    where D2.cod_comp <> C.cod AND D2.cod_gru = D.cod_gru);

--Queries with group by
--20)
select G.nombre, SUM(CL.num)
from GRUPO G, CLUB CL
where G.pais = 'Espa�a' AND G.cod = CL.cod_gru
group by G.cod, G.nombre;

--21)
select G.nombre, COUNT(*)
from GRUPO G, PERTENECE P
where G.cod = P.cod
group by G.cod, G.nombre
having COUNT(*) > 2;

--22)
select G.nombre, COUNT(*)
from GRUPO G, DISCO D
where G.cod = D.cod_gru
group by G.cod, G.nombre;

--23)
select companyia.nombre, COUNT(ESTA.can), dir
from COMPANYIA LEFT JOIN (ESTA NATURAL JOIN DISCO) ON companyia.cod = disco.cod_comp
group by companyia.nombre, companyia.dir
order by nombre;