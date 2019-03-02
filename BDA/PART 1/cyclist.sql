/****CYCLIST****/

--Queries using one single relation
--1)
select code, type, color, prize
from BDA.JERSEY;

--2)
select cnum, name
from BDA.CYCLIST
where age <= 25;

--3)
select stagenum
from BDA.STAGE
where arrival = departure;

--4)
select COUNT(*)
from BDA.CYCLIST;

--5)
select COUNT(*)
from BDA.CYCLIST;

--6)
select COUNT(*)
from BDA.CYCLIST
where age > 25;

--7)
select COUNT(*)
from BDA.TEAM;

--8)
select AVG(age)
from BDA.CYCLIST;

--9)
select MIN(height), MAX(height)
from BDA.CLIMB;

--Queries using more than one relation
--10)
select CL.climbname, CL.category
from BDA.CLIMB CL, BDA.CYCLIST C
where C.cnum = CL.cnum AND C.teamname = 'Banesto';

--11)
select CL.climbname, CL.stagenum, S.km
from BDA.STAGE S, BDA.CLIMB CL
where S.stagenum = CL.stagenum;

--12)
select DISTINCT T.teamname, T.director
from BDA.TEAM T, BDA.CYCLIST C
where T.teamname = C.teamname AND C.age > 33
order by T.teamname;

--13)
select DISTINCT C.name, J.color
from BDA.CYCLIST C, BDA.WEAR W, BDA.JERSEY J
where C.cnum = W.cnum AND W.code = J.code;

--14)
select DISTINCT C.name, S.stagenum
from BDA.CYCLIST C, BDA.STAGE S, BDA.WEAR W, BDA.JERSEY J
where C.cnum = S.cnum AND C.cnum = W.cnum AND 
W.code = J.code AND J.color LIKE 'Amarillo';

--15)
select DISTINCT S2.stagenum
from BDA.STAGE S1, BDA.STAGE S2
where (S1.stagenum+1) = S2.stagenum AND S1.arrival <> S2.departure
order by S2.stagenum;

--Queries using subqueries
--16)
select DISTINCT S.stagenum, S.departure
from BDA.STAGE S
where S.stagenum NOT IN (select C.stagenum from BDA.CLIMB C);

--17)
select AVG(C.age)
from BDA.CYCLIST C
where C.cnum IN (select S.cnum from BDA.STAGE S);

--18)
select CL.climbname
from BDA.CLIMB CL
where CL.height > (select AVG(CL2.height) from BDA.CLIMB CL2);

--19)
select S.departure, S.arrival
from BDA.STAGE S
where S.stagenum IN  
    (select CL.stagenum from BDA.CLIMB CL where CL.slope = 
        (select MAX(CL2.slope) from BDA.CLIMB CL2));

--20)
select C.cnum, C.name
from BDA.CYCLIST C
where C.cnum IN 
    (select CL.cnum from BDA.CLIMB CL where CL.height =  
        (select MAX(CL2.height) from BDA.CLIMB CL2));

--21)
select C.name
from BDA.CYCLIST C
where c.age = (select MIN(C2.age) from BDA.CYCLIST C2);

--22)
select C.name
from BDA.CYCLIST C, BDA.STAGE S
where C.cnum = S.cnum AND C.age = (select MIN(C2.age) 
                                    from BDA.CYCLIST C2, BDA.STAGE S2 
                                    where C2.cnum = S2.cnum);

--23)
select C.name
from BDA.CYCLIST C 
where 1 < (select COUNT(CL.cnum) from BDA.CLIMB CL where CL.cnum = C.cnum);

--Queries with universal quantification
--24)
select S.stagenum
from STAGE S
where S.stagenum NOT IN (select C.stagenum from CLIMB C where C.height <= 700) AND
    S.stagenum IN (select C2.stagenum from CLIMB C2)
order by S.stagenum;

--25)
select T.teamname, T.director
from TEAM T
where T.teamname NOT IN (select C.teamname from CYCLIST C where C.teamname = T.teamname AND C.age <= 25) AND
    T.teamname IN (select C.teamname from CYCLIST C where C.teamname = T.teamname);

--26)
select C.cnum, C.name
from CYCLIST C
where C.cnum IN (select cnum from STAGE) AND C.cnum NOT IN
    (select cnum from STAGE where km <= 170);

--27)
select C.name
from CYCLIST C
where C.cnum IN 
    (select S.cnum 
    from STAGE S 
    where S.stagenum IN (select CL.stagenum from CLIMB CL where CL.cnum = C.cnum) AND 
        S.stagenum NOT IN (select CL.stagenum from CLIMB CL where CL.cnum <> C.cnum));

--28)
select T.teamname
from TEAM T
where T.teamname IN (
    select C.teamname
    from CYCLIST C) 
    AND T.teamname NOT IN (
    select C.teamname
    from CYCLIST C
    where C.cnum NOT IN (select CL.cnum from CLIMB CL) AND
        C.cnum NOT IN (select W.cnum from WEAR W));

--29)
select DISTINCT J.code, J.color
from JERSEY J, WEAR W, CYCLIST C
where J.code = W.code AND W.cnum = C.cnum AND NOT EXISTS 
    (select *
    from CYCLIST C2, WEAR W2
    where C2.teamname <> C.teamname AND C2.cnum = W2.cnum AND W2.code = W.code);

--30)
select DISTINCT C.teamname
from CYCLIST C, CLIMB CL
where C.cnum = CL.cnum AND NOT EXISTS
    (select *
    from CYCLIST C2, CLIMB CL2
    where C2.cnum = CL2.cnum AND CL2.category <> '1' AND C2.teamname = C.teamname);

--Queries with group by
--31)
select S.stagenum, COUNT(*)
from STAGE S, CLIMB CL
where S.stagenum = CL.stagenum
group by S.stagenum
order by S.stagenum;

--32)
select T.teamname, COUNT(*)
from TEAM T, CYCLIST C
where T.teamname = C.teamname
group by T.teamname
order by T.teamname;

--33)
select teamname, COUNT(CYCLIST.cnum)
from TEAM NATURAL LEFT JOIN CYCLIST
group by teamname;

--34)
select T.director, T.teamname
from TEAM T, CYCLIST C
where T.teamname = C.teamname
group by T.teamname, T.director
having  COUNT(*) > 3 AND AVG(C.age) <=30
order by T.director;

--35)
select DISTINCT C.name, COUNT(*)
from CYCLIST C, STAGE S
where C.cnum = S.cnum AND C.teamname IN
    (select C2.teamname
    from CYCLIST C2
    group by C2.teamname
    HAVING COUNT(*) > 5)
group by C.cnum, C.name
order by C.name;

--36)
select C.teamname, AVG(C.age)
from CYCLIST C
group by C.teamname
having AVG(C.age) >=
    ALL (select AVG(C2.age)
    from CYCLIST C2
    group by C2.teamname);

--37)
select T.director, COUNT(*)
from TEAM T, CYCLIST C, WEAR W
where T.teamname = C.teamname AND C.cnum = W.cnum
group by T.director
having COUNT(*) >=
    ALL (select COUNT(*)
    from TEAM T2, CYCLIST C2, WEAR W2
    where T2.teamname = C2.teamname AND C2.cnum = W2.cnum
    group by T2.teamname);