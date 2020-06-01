-- Recapitulare 1 - Andronic Alexandra 231
-- Exercitiul 1
select denumire
from excursie e join achizitioneaza a 
        on e.id_excursie = a.cod_excursie
where data_start = (select min(data_start)
                    from achizitioneaza);
                    
-- sau cu subcerere in from
select *
from (select denumire
      from excursie e join achizitioneaza a
      on e.id_excursie = a.cod_excursie
      order by data_start)
where rownum = 1;

-- Exercitiul 2 - TEMA
select denumire, count(denumire)
from excursie
group by (denumire);

-- Exercitiul 3 - Tema
select a.denumire, a.oras, count(e.denumire), avg(pret)
from excursie e join agentie a on e.cod_agentie = a.id_agentie
group by a.denumire, a.oras;

-- Exercitiul 4
-- a
select nume, prenume, count(cod_excursie) nr_excursii
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
group by t.id_turist, nume, prenume
having count(cod_excursie) >= 2;
-- b
select count(*) nr_turisti
from (select 'x'
      from turist t join achizitioneaza a
      on t.id_turist = a.cod_turist
      group by t.id_turist
      having count(cod_excursie) >= 2);
      
-- Exercitiul 5 - Tema
select nume, prenume
from turist 
where (nume, prenume) not in (select  nume, prenume
                         from turist t join achizitioneaza a
                         on t.id_turist = a.cod_turist
                         join excursie ex on ex.id_excursie = a.cod_excursie
                         where upper(destinatie) = 'PARIS');

-- Exercitiul 6 - Tema
select nume, prenume, count(cod_excursie)
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
group by nume, prenume
having count(cod_excursie) >= 2;

-- Exercitiul 7
select  a.denumire, sum(ex.pret - ex.pret * NVL(ac.discount, 0)) Profit
from agentie a join excursie ex on a.id_agentie = ex.cod_agentie
               join achizitioneaza ac on ac.cod_excursie = ex.id_excursie
group by a.denumire;

-- Exercitiul 8
select a.denumire, a.oras
from agentie a
where 3 <= (select count(ex.id_excursie)
            from excursie ex
            where a.id_agentie = ex.cod_agentie
            and pret < 2000);
            
-- Exercitiul 9 - Tema
select id_excursie, denumire
from excursie
where id_excursie not in (select cod_excursie
                          from achizitioneaza);

-- Exercitiul 10 - Tema
select ex.denumire Denumire, ex.pret Pret, NVL(a.denumire, 'agentie necunoscuta') den_agentie
from excursie ex left join agentie a on ex.cod_agentie = a.id_agentie;

-- Exercitiul 11
select ex.denumire, ex.pret
from excursie ex
where ex.pret >ALL (select pret
                 from excursie
                 where upper(denumire) = 'ORASUL LUMINILOR' and cod_agentie = 10);


-- Exercitiul 12
select nume, prenume, (data_end - data_start) Durata
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
where (data_end - data_start) >= 10;

-- Exercitiul 13 - Tema
select nume, prenume, a.cod_excursie
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
where (SYSDATE - data_nastere) / 365 <= 35;

-- Exercitiul 14 - Tema
select nume, prenume
from turist
where id_turist not in (select id_turist
                        from turist t join achizitioneaza a on t.id_turist = a.cod_turist
                        join excursie ex on ex.id_excursie = a.cod_excursie
                        join agentie ag on ag.id_agentie = ex.cod_agentie
                        where upper(oras) = 'BUCURESTI');
            
-- Exercitiul 15
select nume, prenume
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
                        join excursie ex on ex.id_excursie = a.cod_excursie
                        join agentie ag on ag.id_agentie = ex.cod_agentie
where lower(ex.denumire) like ('%1 mai%') and upper(ag.oras) = 'BUCURESTI';

-- Exercitiul 16 - Tema
select nume, prenume, ex.denumire
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
                        join excursie ex on ex.id_excursie = a.cod_excursie
                        join agentie ag on ag.id_agentie = ex.cod_agentie
where upper(ag.denumire) = 'SMART TOUR';

-- Exercitiul 17
select id_excursie, ex.denumire
from excursie ex join achizitioneaza a
on ex.id_excursie = a.cod_excursie
where to_char(data_start, 'dd-mon-yyyy') = '14-aug-2011'
group by id_excursie, ex.denumire, nr_locuri
having nr_locuri - count(a.cod_turist) = 0;


-- Exercitiul 18 - Tema
select cod_turist, max(data_achizitie)
from achizitioneaza
group by cod_turist;
-- Exercitiul 19 - Tema
select * 
from (select denumire, pret
      from excursie
      order by pret desc)
where rownum <= 5;

-- Exercitiul 20 - Tema
select nume, prenume, data_achizitie
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
where to_char(data_nastere,'mon') = to_char(data_achizitie, 'mon');

-- Exercitiul 21 - Tema
select nume, prenume
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
                        join excursie ex on ex.id_excursie = a.cod_excursie
                        join agentie ag on ag.id_agentie = ex.cod_agentie
where nr_locuri = 2 and upper(ag.oras) = 'CONSTANTA';

-- Exercitiul 22 - Tema
with dur as (select id_excursie,
                case
                when durata <= 5 then 'mica'
                when durata <= 19 then 'medie'
                else
                'lunga'
                end as durata_excursie,
                durata
            from excursie)
select id_excursie, durata_excursie
from dur
order by durata;

-- Exercitiul 23
select count(id_excursie) "Numar Excursii", DECODE(oras, 'Constanta', count(id_excursie)) "Nr.Constanta",
        decode(oras, 'Bucuresti', count(id_excursie)) "Nr.Bucuresti"
from excursie ex join agentie ag on ex.cod_agentie = ag.id_agentie
group by id_agentie, oras;

-- Exercitiul 24 - Tema
select nume, prenume, a.cod_excursie
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
where round(SYSDATE - data_nastere) / 365 = 24;

-- Exercitiul 25 - Tema
select id_agentie, destinatie, sum(pret - pret * NVL(discount, 0)) profit, grouping(id_agentie), grouping(destinatie)
from turist t join achizitioneaza a on t.id_turist = a.cod_turist
                        join excursie ex on ex.id_excursie = a.cod_excursie
                        join agentie ag on ag.id_agentie = ex.cod_agentie
group by grouping sets((id_agentie, destinatie), (id_agentie), ());

-- Exercitiul 26 - Tema
with pret_mediu as(select id_agentie, oras, avg(pret) pret
                   from agentie ag join excursie ex on ag.id_agentie = ex.cod_agentie
                   group by id_agentie, oras)
select ag.oras, ag.id_agentie, pret_mediu.id_agentie ag_concurenta, pret_mediu.pret pret_concurent
from agentie ag left join pret_mediu on ag.oras = pret_mediu.oras
where ag.id_agentie <> pret_mediu.id_agentie;
