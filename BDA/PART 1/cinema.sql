/****CINEMA****/

--Queries using one single relation
--1)
select DISTINCT COD_PAIS
from BDA.CS_ACTOR
order by COD_PAIS ASC;

--2)
select COD_PELI, TITULO
from BDA.CS_PELICULA
where ANYO < 1970 AND COD_LIB IS NULL
order by TITULO;

--3)
select COD_ACT, NOMBRE
from BDA.CS_ACTOR
where NOMBRE like '%John%';

--4)
select COD_PELI, TITULO
from BDA.CS_PELICULA
where (anyo BETWEEN 1980 AND 1989) AND DURACION > 120;

--5)
select COD_PELI, TITULO
from BDA.CS_PELICULA
where NOT (COD_LIB IS NULL) AND DIRECTOR LIKE '%Pakula%';

--6)
select COUNT(*)
from BDA.CS_PELICULA
where (anyo BETWEEN 1980 AND 1989) AND DURACION > 120;

--7)
select COUNT(DISTINCT COD_PELI) AS How_Many_Films
from BDA.CS_CLASIFICACION
where COD_GEN IN ('BB5', 'GG4','JH6');

--8)
select MIN(anyo)
from BDA.CS_LIBRO;

--9)
select AVG(DURACION)
from BDA.CS_PELICULA
where anyo = 1987;

--10)
select SUM(duracion)
from BDA.CS_PELICULA
where director = 'Steven Spielberg';

--Queries using more than one relation
--11)
select P.cod_peli, P.titulo
from BDA.CS_ACTOR A, BDA.CS_PELICULA P, BDA.CS_ACTUA AC
where AC.cod_act = A.cod_act AND AC.cod_peli = P.cod_peli AND A.nombre = P.director
order by P.titulo

--12)
select P.cod_peli, P.titulo 
from BDA.CS_PELICULA P, BDA.CS_GENERO G, BDA.CS_CLASIFICACION C
where C.cod_gen = G.cod_gen AND C.cod_peli = P.cod_peli AND G.nombre = 'Comedia'
order by P.TITULO;

--13)
select P.cod_peli, P.titulo
from BDA.CS_PELICULA P, BDA.CS_LIBRO L
where P.cod_lib = L.cod_lib AND L.anyo < 1950;

--14)
select DISTINCT PA.cod_pais, PA.nombre
from BDA.CS_PAIS PA, BDA.CS_ACTOR A, BDA.CS_ACTUA AC, BDA.CS_GENERO G, 
BDA.CS_CLASIFICACION CL, BDA.CS_PELICULA P
where G.nombre = 'Comedia' AND PA.cod_pais = A.cod_pais AND A.cod_act = AC.cod_act 
AND AC.cod_peli = P.cod_peli AND P.cod_peli = CL.cod_peli AND CL.cod_gen = G.cod_gen
order by PA.nombre;

--Queries using subqueries
--15a)
select P.cod_peli, P.titulo
from BDA.CS_PELICULA P, BDA.CS_ACTUA AC
where P.cod_peli = AC.cod_peli AND P.director IN (select A.nombre 
                                                from BDA.CS_ACTOR A
                                                where A.cod_act = AC.cod_act)
order by P.titulo;

--15b)
select P.cod_peli, P.titulo
from BDA.CS_PELICULA P
where cod_peli IN(select C.cod_peli
                from BDA.CS_CLASIFICACION C
                where C.cod_gen IN (select G.cod_gen
                                    from BDA.CS_GENERO G
                                    where G.nombre = 'Comedia'))
order by P.titulo;

--15c)
select P.cod_peli, P.titulo
from BDA.CS_PELICULA P
where P.cod_lib IN (select B.cod_lib
                    from BDA.CS_LIBRO B
                    where B.anyo < 1950);

--15d)
select P.cod_pais, P.nombre
from BDA.CS_PAIS P
where P.cod_pais IN 
    (select A.cod_pais
    from BDA.CS_ACTOR A
    where A.cod_act IN
        (select AA.cod_act
        from BDA.CS_ACTUA AA
        where AA.cod_peli IN
            (select P.cod_peli
            from BDA.CS_PELICULA P
            where p.cod_peli IN
                (select C.cod_peli
                from BDA.CS_CLASIFICACION C
                where C.cod_gen IN 
                    (select G.cod_gen
                    from BDA.CS_genero G
                    where G.nombre = 'Comedia')))));

--16)
select A.cod_act, A.nombre
from BDA.CS_ACTOR A
where extract(year from A.fecha_nac) < 1950 AND A.cod_act IN 
    (select AC.cod_act from BDA.CS_ACTUA AC where papel = 'Principal')
order by A.nombre;

--17)
select B.cod_lib, B.titulo, B.autor
from BDA.CS_LIBRO B
where B.cod_lib IN 
    (select P.cod_lib from BDA.CS_PELICULA P where P.anyo BETWEEN 1990 AND 1999)
order by B.titulo;

--18)
select B.cod_lib, B.titulo, B.autor
from BDA.CS_LIBRO B
where B.cod_lib NOT IN 
    (select P.cod_lib from BDA.CS_PELICULA P where P.cod_lib IS NOT NULL)
order by B.titulo;

--19)
select G.nombre
from BDA.CS_GENERO G
where G.cod_gen IN (
    select C.cod_gen from BDA.CS_CLASIFICACION C where C.cod_peli IN 
        (select P.cod_peli from BDA.CS_PELICULA P where P.cod_peli NOT IN
            (select cod_peli from BDA.CS_actua)));

--20)
SELECT titulo
FROM cs_libro
WHERE cod_lib IN (
    SELECT cod_lib
    FROM cs_pelicula
    WHERE cod_lib IS NOT NULL
    AND cod_peli NOT IN (
        SELECT cod_peli
        FROM cs_actua
        WHERE cod_act IN (
            SELECT cod_act
            FROM cs_actor
            WHERE cod_pais IN (
                SELECT cod_pais
                FROM cs_pais
                WHERE nombre = 'USA'
            )
        )
    )
) ORDER BY titulo;


--21)
select COUNT(P.cod_peli)
from BDA.CS_PELICULA P, BDA.CS_CLASIFICACION CL, BDA.CS_GENERO G
where P.cod_peli = CL.cod_peli AND 
    CL.cod_gen = G.cod_gen AND G.nombre = 'Comedia' AND 1 =
        (select COUNT(AC.cod_act)
        from BDA.CS_ACTUA AC
        where AC.cod_peli = P.cod_peli AND AC.papel = 'Secundario');

--22)
select MIN(P.anyo)
from BDA.CS_PELICULA P
where P.cod_peli IN 
    (select AC.cod_peli
    from BDA.CS_ACTOR A, BDA.CS_ACTUA AC
    where A.cod_act = AC.cod_act AND A.nombre = 'Jude Law' AND 
    AC.papel = 'Principal');

--23)
select A.cod_act, A.nombre
from BDA.CS_ACTOR A
where A.fecha_nac = (select MIN(AA.fecha_nac) from BDA.CS_ACTOR AA);

--24)
select A.cod_act, A.nombre, A.fecha_nac
from BDA.CS_ACTOR A
where A.fecha_nac = (select MIN(AA.fecha_nac) from BDA.CS_ACTOR AA where 1940 = EXTRACT(YEAR from AA.fecha_nac));

--25)
select G.nombre
from BDA.CS_CLASIFICACION CL, BDA.CS_GENERO G, BDA.CS_PELICULA P
where G.cod_gen = CL.cod_gen AND CL.cod_peli = P.cod_peli AND 
    P.duracion = (select MAX(PP.duracion) from BDA.CS_PELICULA Pp);

--26)
SELECT cod_lib, titulo
FROM cs_libro
WHERE cod_lib IN (
    SELECT cod_lib
    FROM cs_pelicula
    WHERE cod_peli IN (
        SELECT cod_peli
        FROM cs_actua
        WHERE cod_act IN (
            SELECT cod_act
            FROM cs_actor
            WHERE cod_pais IN (
                SELECT cod_pais
                FROM cs_pais
                WHERE nombre = 'Espa�a'
            )
        )
    )
) ORDER BY titulo;

--27)
select P.titulo
from BDA.CS_PELICULA P
where P.anyo < 1950 AND 
    1 < (select COUNT(CL.cod_gen)
        from BDA.CS_CLASIFICACION CL 
        where CL.cod_peli = P.cod_peli)
order by P.titulo;

--28)
select COUNT(DISTINCT P.cod_peli)
from BDA.CS_PELICULA P
where 4 > (select COUNT(AC.cod_peli)
            from BDA.CS_ACTUA AC
            where P.cod_peli = AC.cod_peli);

--29)
select DISTINCT P.director
from BDA.CS_PELICULA P
where 250 < (select SUM(PP.duracion) from BDA.CS_PELICULA PP where PP.director = P.director);

--30)
SELECT DISTINCT EXTRACT(YEAR FROM a.fecha_nac)
FROM cs_actor a
WHERE 3 < (
    SELECT COUNT(a2.cod_act)
    FROM cs_actor a2
    WHERE EXTRACT(YEAR FROM a.fecha_nac) = EXTRACT(YEAR FROM a2.fecha_nac));

--31)
select A1.cod_act, A1.nombre
from BDA.CS_ACTOR A1
where A1.fecha_nac = (select MAX(A2.fecha_nac)
                    from BDA.CS_ACTOR A2, BDA.CS_ACTUA AC, BDA.CS_PELICULA P,
                    BDA.CS_CLASIFICACION CL
                    where A2.cod_act = AC.cod_act AND AC.cod_peli = P.cod_peli AND
                    P.cod_peli = CL.cod_peli AND CL.cod_gen = 'DD8');

--Queries with universal quantification
--32)
select DISTINCT PA.cod_pais, PA.nombre
from CS_PAIS PA, CS_Actor A1
where PA.cod_pais = A1.cod_pais AND PA.cod_pais NOT IN 
    (select cod_pais
    from CS_ACTOR
    where EXTRACT(year from fecha_nac) NOT BETWEEN 1900 AND 1999)
order by PA.nombre;

--33)
select A.cod_act, A.nombre
from CS_ACTOR A
where A.cod_act IN (select cod_act from CS_ACTUA where papel = 'Secundario')
    AND A.cod_act NOT IN (select cod_act from CS_ACTUA where papel <> 'Secundario');

--34)
select A.cod_act, A.nombre
from CS_ACTOR A
where NOT EXISTS
    (select *
    from CS_PELICULA P
    where P.director = 'Guy Ritchie' AND P.cod_peli NOT IN
        (select AC.cod_peli
        from CS_ACTUA AC
        where A.cod_act = AC.cod_act)) AND EXISTS
    (select *
    from CS_PELICULA P
    where P.director = 'Guy Ritchie' AND P.cod_peli IN
        (select AC.cod_peli
        from CS_ACTUA AC
        where A.cod_act = AC.cod_act));

--35)
select A.cod_act, A.nombre
from CS_ACTOR A
where NOT EXISTS
    (select *
    from CS_PELICULA P
    where P.director = 'John Steel' AND P.cod_peli NOT IN
        (select AC.cod_peli
        from CS_ACTUA AC
        where A.cod_act = AC.cod_act)) AND EXISTS
    (select *
    from CS_PELICULA P
    where P.director = 'John Steel' AND P.cod_peli IN
        (select AC.cod_peli
        from CS_ACTUA AC
        where A.cod_act = AC.cod_act));

--36)
select DISTINCT P.cod_peli, P.titulo
from CS_PELICULA P, CS_ACTUA AC, CS_ACTOR A1
where P.duracion < 100 AND P.cod_peli = AC.cod_peli AND AC.cod_act = A1.cod_act AND
    NOT EXISTS (select *
    from CS_ACTOR A2
    where A2.cod_pais <> A1.cod_pais AND A2.cod_act IN
        (select AC.cod_act
        from CS_ACTUA AC
        where AC.cod_peli = P.cod_peli));

--37)
select DISTINCT P.cod_peli, P.titulo, P.anyo
from CS_PELICULA P, CS_ACTUA AC, CS_ACTOR A
where P.cod_peli = AC.cod_peli AND AC.cod_act = A.cod_act AND EXTRACT(year from A.FECHA_NAC) < 1943 AND
NOT EXISTS(
    select *
    from CS_ACTOR A2    
    where EXTRACT(year from A2.FECHA_NAC) >= 1943 AND A2.cod_act IN (
        select AC2.cod_act
        from CS_ACTUA AC2
        where AC2.cod_peli = P.cod_peli))
order by P.titulo;

--38)
select DISTINCT PA.cod_pais, PA.nombre
from CS_PAIS PA, CS_ACTOR A, CS_ACTUA AC, CS_PELICULA P
where PA.cod_pais = A.cod_pais AND A.cod_act = AC.cod_act AND AC.cod_peli = P.cod_peli AND
P.duracion > 120 AND NOT EXISTS(
    select *
    from CS_ACTOR A2
    where A2.cod_pais = PA.cod_pais AND NOT EXISTS (
        select *
        from CS_ACTUA AC2
        where A2.cod_act = AC2.cod_act AND AC2.cod_peli IN (
            select P2.cod_peli
            from CS_PELICULA P2
            where P2.duracion > 120)))
order by PA.nombre;

--Queries with group by
--39)
select L.cod_lib, L.titulo, COUNT(P.cod_lib)
from CS_LIBRO L, CS_PELICULA P
where L.cod_lib = P.cod_lib
group by L.cod_lib, L.titulo
having COUNT(P.cod_lib) > 1;

--40)
select G.cod_gen, G.nombre, COUNT(P.cod_peli), ROUND(AVG(P.duracion))
from CS_GENERO G, CS_CLASIFICACION CL, CS_PELICULA P
where G.cod_gen = CL.cod_gen AND CL.cod_peli = P.cod_peli
group by G.cod_gen, G.nombre
having COUNT(P.cod_peli) > 5
order by G.nombre;

--41)
select DISTINCT P.cod_peli, P.titulo, COUNT(CL.cod_gen)
from CS_PELICULA P, CS_CLASIFICACION CL
where P.anyo > 2000 AND P.cod_peli = CL.cod_peli AND CL.cod_gen IS NOT NULL
group by P.cod_peli, P.titulo
order by P.titulo;

--42)
select P.director
from CS_PELICULA P
where P.director LIKE '%George%'
group by P.director
having COUNT(P.director) = 2;

--43)
select DISTINCT P.cod_peli, P.titulo, COUNT(*)
from CS_PELICULA P, CS_ACTUA AC
where P.cod_peli = AC.cod_peli AND 1 = (
    select COUNT(CL2.cod_gen)
    from CS_CLASIFICACION CL2
    where CL2.cod_peli = P.cod_peli)
group by P.cod_peli, P.titulo
order by P.titulo;

--44)
select PA.cod_pais, PA.nombre, COUNT(DISTINCT A.cod_act)
from CS_PAIS PA, CS_ACTOR A, CS_ACTUA AC, CS_PELICULA P
where PA.cod_pais = A.cod_pais AND A.cod_act = AC.cod_act  
AND AC.cod_peli = P.cod_peli AND P.anyo BETWEEN 1960 AND 1969
group by PA.cod_pais, PA.nombre
order by PA.nombre;

--45)
select G.cod_gen, G.nombre
from CS_GENERO G, CS_CLASIFICACION CL
where G.cod_gen = CL.cod_gen
group by G.cod_gen, G.nombre
having COUNT(*) = 
    (select MAX(COUNT(*))
    from CS_CLASIFICACION CL2
    group by CL2.cod_gen);

--46)
select L.cod_lib, L.titulo, L.autor
from CS_LIBRO L, CS_PELICULA P
where L.cod_lib = P.cod_lib
group by L.cod_lib, L.titulo, L.autor
having COUNT(*) >=
    ALL (select COUNT(*)
    from CS_LIBRO L2, CS_PELICULA P2
    where L2.cod_lib = P2.cod_lib
    group by L2.cod_lib);

--47)
SELECT cod_pais, cs_pais.nombre
FROM cs_pais LEFT JOIN cs_actor USING (cod_pais)
WHERE cod_act IN (
    SELECT cod_act
    FROM cs_actua
    GROUP BY cod_act
    HAVING COUNT(DISTINCT cod_peli) = 2
) GROUP BY cod_pais, cs_pais.nombre
HAVING COUNT(cod_act) >= ALL (
    SELECT COUNT(cod_act)
    FROM cs_pais LEFT JOIN cs_actor USING (cod_pais)
    WHERE cod_act IN (
        SELECT cod_act
        FROM cs_actua
        GROUP BY cod_act
        HAVING COUNT(DISTINCT cod_peli) = 2
    ) GROUP BY cod_pais
);

--48)
select EXTRACT(year from A.fecha_nac), COUNT(A.cod_act)
from CS_ACTOR A
group by EXTRACT(year from A.fecha_nac)
having COUNT(EXTRACT(year from A.fecha_nac)) > 3;

--49)
select P.cod_peli, P.titulo
from CS_PELICULA P, CS_ACTUA AC, CS_ACTOR A
where P.duracion < 100 AND P.cod_peli = AC.cod_peli AND AC.cod_act = A.cod_act
group by P.cod_peli, P.titulo
having COUNT(DISTINCT A.cod_pais) = 1;

--Queries with different joins
--50)
select CS_PAIS.cod_pais, CS_PAIS.nombre, COUNT(CS_ACTOR.cod_act)
from CS_PAIS LEFT JOIN CS_ACTOR ON CS_PAIS.COD_PAIS = CS_ACTOR.COD_PAIS
group by CS_PAIS.cod_pais, CS_PAIS.nombre

--51)
select L.cod_lib, L.titulo, COUNT(P.cod_peli)
from CS_LIBRO L LEFT JOIN CS_PELICULA P ON L.cod_lib = P.cod_lib
where L.anyo > 1980
group by L.cod_lib, L.titulo;

--52)
select PA.cod_pais, PA.nombre, COUNT(DISTINCT A.cod_act)
from CS_PAIS PA LEFT JOIN (CS_ACTOR A JOIN CS_ACTUA AC ON AC.papel = 'Secundario' 
AND  AC.cod_act = A.cod_act) ON Pa.cod_pais = A.cod_pais
group by PA.cod_pais, PA.nombre
order by PA.nombre;

--53)
select P.cod_peli, P.titulo, COUNT(DISTINCT AC.cod_act), COUNT(DISTINCT CL.cod_gen)
from (CS_PELICULA P LEFT JOIN CS_ACTUA AC ON P.cod_peli = AC.cod_peli) LEFT JOIN
CS_CLASIFICACION CL ON P.cod_peli = CL.cod_peli
where P.duracion > 140
group by P.cod_peli, P.titulo
order by P.titulo;

--Queries with set operation
--54)
(select anyo
from CS_LIBRO
where anyo IS NOT NULL AND anyo NOT LIKE '%9%'
UNION
select anyo
from CS_PELICULA
where anyo IS NOT NULL AND anyo NOT LIKE '%9%')
order by anyo ASC;