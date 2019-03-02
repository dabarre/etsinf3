/****BIBLIOTECA****/

--Queries using one single relation
--1)
select nombre
from BDA.AUTOR
where nacionalidad = 'Argentina';

--2)
select titulo
from BDA.OBRA
where titulo LIKE '%mundo%';

--3)
select id_lib, num_obras
from BDA.LIBRO
where "A�O" < 1990 AND num_obras > 1;

--4)
select COUNT(*) AS LIB_A�O
from BDA.LIBRO
where "A�O" IS NOT NULL;

--5)
select COUNT(*)
from BDA.LIBRO
where num_obras > 1;

--6)
select id_lib
from BDA.LIBRO
where "A�O" = 1997 AND TITULO IS NULL;

--7)
select TITULO
from BDA.LIBRO
where TITULO IS NOT NULL
order by TITULO DESC;

--8)
select SUM(num_obras) AS OBRAS
from BDA.LIBRO
where a�o BETWEEN 1990 AND 1999;

--Queries using more than one relation
--9)
select COUNT(DISTINCT A.autor_id) AS Autores
from BDA.AUTOR A, BDA.ESCRIBIR E, BDA.OBRA O
where A.autor_id = E.autor_id AND E.cod_ob = O.cod_ob AND O.titulo LIKE '%ciudad%';

--10)
select O.titulo
from BDA.OBRA O, BDA.ESCRIBIR E, BDA.AUTOR A
where O.cod_ob = E.cod_ob AND E.autor_id = A.autor_id AND A.nombre = 'Cam�s, Albert';

--11)
select A.nombre
from BDA.AUTOR A, BDA.ESCRIBIR E, BDA.OBRA O
where A.autor_id = E.autor_id AND E.cod_ob = O.cod_ob AND O.titulo LIKE 'La tata'

--12)
select DISTINCT AM.nombre
from BDA.AUTOR A, BDA.ESCRIBIR E, BDA.OBRA O, BDA.LEER L, BDA.AMIGO AM
where A.autor_id = 'RUKI' AND A.autor_id = E.autor_id
    AND E.cod_ob = O.cod_ob AND O.cod_ob = L.cod_ob AND L.num = AM.num

--13)
select DISTINCT B.id_lib, B.titulo
from BDA.LIBRO B, BDA.ESTA_EN E1, BDA.ESTA_EN E2
where B.id_lib = E1.id_lib AND B.id_lib = E2.id_lib AND B.titulo IS NOT NULL;

--Queries with subqueries
--14)
select O.titulo, A.nombre
from BDA.AUTOR A, BDA.OBRA O
where A.nacionalidad = 'Francesa'  AND  1 = (select COUNT(E.autor_id)
                                    from BDA.ESCRIBIR E
                                    where A.autor_id = E.autor_id AND E.cod_ob = O.cod_ob);

--15)
select COUNT(A.autor_id) AS SIN_OBRA
from BDA.AUTOR A
where A.autor_id NOT IN (select E.autor_id from BDA.ESCRIBIR E);

--16)
select A.nombre
from BDA.AUTOR A
where A.autor_id NOT IN (select E.autor_id from BDA.ESCRIBIR E);

--17)
select A.nombre
from BDA.AUTOR A
where A.nacionalidad = 'Espa�ola' AND 2 <= 
    (select COUNT(E.autor_id) from BDA.ESCRIBIR E where A.autor_id = E.autor_id);

--18)
select DISTINCT A.nombre
from BDA.AUTOR A, BDA.ESCRIBIR E, BDA.OBRA O
where A.nacionalidad = 'Espa�ola' AND E.autor_id = A.autor_id AND
    E.cod_ob = O.cod_ob AND 2 <= (select COUNT(ES.cod_ob)
                                    from BDA.ESTA_EN ES
                                    where ES.cod_ob = O.cod_ob);

--19)
select O.cod_ob, O.titulo
from BDA.OBRA O
where 1 < (select COUNT(E.cod_ob)
            from BDA.ESCRIBIR E 
            where E.cod_ob = O.cod_ob);

--Queries with universal quantification
--20)
select DISTINCT A.nombre
from AMIGO A, LEER L, OBRA O, ESCRIBIR E
where A.num = L.num AND L.cod_ob = O.cod_ob AND O.cod_ob = E.cod_ob AND 
E.autor_id = 'RUKI' AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id = 'RUKI' AND E2.cod_ob NOT IN 
        (select O2.cod_ob
        from OBRA O2, LEER L2
        where O2.cod_ob = L2.cod_ob AND L2.num = A.num));

--21)
select DISTINCT A.nombre
from AMIGO A, LEER L, OBRA O, ESCRIBIR E
where A.num = L.num AND L.cod_ob = O.cod_ob AND O.cod_ob = E.cod_ob AND 
E.autor_id = 'GUAP' AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id = 'GUAP' AND E2.cod_ob NOT IN 
        (select O2.cod_ob
        from OBRA O2, LEER L2
        where O2.cod_ob = L2.cod_ob AND L2.num = A.num));

--22)
select DISTINCT AM.nombre
from AMIGO AM, LEER L, ESCRIBIR E
where AM.num = L.num AND L.cod_ob = E.cod_ob AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id = E.autor_id AND E2.cod_ob NOT IN 
        (select L2.cod_ob
        from LEER L2
        where L2.num = AM.num));

--23)
select DISTINCT AM.nombre, AU.nombre
from AMIGO AM, LEER L, ESCRIBIR E, AUTOR AU
where AM.num = L.num AND L.cod_ob = E.cod_ob AND E.autor_id = AU.autor_id
AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id = E.autor_id AND E2.cod_ob NOT IN 
        (select L2.cod_ob
        from LEER L2
        where L2.num = AM.num))

--24)
select DISTINCT A.nombre
from AMIGO A, LEER L
where A.num = L.num AND NOT EXISTS 
    (select *
    from LEER L2
    where A.num = L2.num AND NOT EXISTS
        (select *
        from ESCRIBIR E2
        where L2.cod_ob = E2.cod_ob AND E2.autor_id = 'CAMA'));

--25)
select DISTINCT A.nombre
from AMIGO A, LEER L
where A.num = L.num AND NOT EXISTS 
    (select *
    from LEER L2
    where A.num = L2.num AND NOT EXISTS
        (select *
        from ESCRIBIR E2
        where L2.cod_ob = E2.cod_ob AND E2.autor_id = 'GUAP'));

--26)
select DISTINCT A.nombre
from AMIGO A, LEER L, ESCRIBIR E
where A.num = L.num AND L.cod_ob = E.cod_ob AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id <> E.autor_id AND E2.cod_ob IN 
        (select L2.cod_ob
        from LEER L2
        where L2.num = A.num));

--27)
select DISTINCT A.nombre, AU.nombre
from AMIGO A, LEER L, ESCRIBIR E, AUTOR AU
where A.num = L.num AND L.cod_ob = E.cod_ob AND E.autor_id = AU.autor_id
AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id <> E.autor_id AND E2.cod_ob IN 
        (select L2.cod_ob
        from LEER L2
        where L2.num = A.num));

--28)
select DISTINCT AM.nombre, AU.nombre
from AMIGO AM, LEER L, ESCRIBIR E, AUTOR AU
where AM.num = L.num AND L.cod_ob = E.cod_ob AND E.autor_id = AU.autor_id
AND NOT EXISTS
    (select *
    from ESCRIBIR E2
    where E2.autor_id = E.autor_id AND E2.cod_ob NOT IN 
        (select L2.cod_ob
        from LEER L2
        where L2.num = AM.num))
AND NOT EXISTS
    (select *
    from ESCRIBIR E3
    where E3.autor_id <> E.autor_id AND E3.cod_ob IN 
        (select L3.cod_ob
        from LEER L3
        where L3.num = AM.num))

--Queries with group by
--29)
select L.id_lib, L.titulo
from LIBRO L, ESTA_EN E
where L.id_lib = E.id_lib AND L.titulo IS NOT NULL
group by L.id_lib, L.titulo
having COUNT(*) > 1;

--30)
select A.nombre, COUNT(*)
from AMIGO A, LEER E
where A.num = E.num
group by A.nombre
having COUNT(*) > 3;

--31)
select O.tematica, COUNT(*)
from OBRA O
where O.tematica IS NOT NULL
group by O.tematica
order by O.tematica;

--32)
select T.tematica, COUNT(cod_ob)
from TEMA T LEFT JOIN OBRA O ON T.tematica = O.tematica
group by T.tematica
order by T.tematica;

--33)
select A.nombre
from AUTOR A, ESCRIBIR E
where A.autor_id = E.autor_id
group by A.nombre
having COUNT(*) >= 
    ALL (select COUNT(*)
    from AUTOR A2, ESCRIBIR E2
    where A2.autor_id = E2.autor_id
    group by A2.autor_id);

--34)
select A.nacionalidad
from AUTOR A
group by A.nacionalidad
having COUNT(*) <= 
    ALL (select COUNT(*)
    from AUTOR A2
    group by A2.nacionalidad)
order by A.nacionalidad;

--35)
select A.nombre
from AMIGO A, LEER L
where A.num = L.num
group by A.nombre
having COUNT(*) >=
    ALL (select COUNT(*)
    from AMIGO A2, LEER L2
    where A2.num = L2.num
    group by A2.nombre);