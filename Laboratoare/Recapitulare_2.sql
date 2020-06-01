-- Recapitulare 2

-- Exercitiul 27
desc achizitioneaza;
desc excursie;
-- varianta 1
select destinatie, cod_agentie, sum(pret)
from excursie
group by cube(cod_agentie, destinatie)
order by 1, 2;

-- varianta 2
select destinatie, cod_agentie, sum(pret)
from excursie
group by grouping sets((cod_agentie, destinatie), (cod_agentie), (destinatie), ())
order by 1, 2;

-- Exercitiul 28
select cod_agentie, to_char(data_achizitie, 'yyyy') an, sum(e.pret * (1-discount)) suma
from excursie e join achizitioneaza a on a.cod_excursie = e.id_excursie
group by grouping sets ((cod_agentie, to_char(data_achizitie, 'yyyy')), ());

-- Exercitiul 29
desc excursie;
desc turist;
desc achizitioneaza;
select denumire
from excursie ex
where ex.cod_agentie is null
and not exists (
    select 1
    from turist t join achizitioneaza ac on t.id_turist = ac.cod_turist
    where to_char(data_nastere, 'YYYY') = '1984' and cod_excursie = ex.id_excursie
);

select ex.denumire
from excursie ex
where ex.cod_agentie is null
and ex.id_excursie not in (
    select cod_excursie
    from turist join achizitioneaza on cod_turist = id_turist
    where to_char(data_nastere, 'YYYY') = '1984'
    
);

-- Exercitiul 30
CREATE TABLE turist_aan AS SELECT * FROM turist;
CREATE TABLE achizitioneaza_aan AS 
    SELECT * FROM achizitioneaza;
CREATE TABLE excursie_aan AS 
    SELECT * FROM excursie;
CREATE TABLE agentie_aan AS 
    SELECT * FROM agentie;
    
ALTER TABLE turist_aan
ADD CONSTRAINT pk_turist_aan PRIMARY KEY(id_turist);

ALTER TABLE achizitioneaza_aan
ADD CONSTRAINT pk_achizitioneaza_aan PRIMARY KEY(cod_turist, cod_excursie, data_start);

ALTER TABLE excursie_aan
ADD CONSTRAINT pk_excursie_aan PRIMARY KEY(id_excursie);

ALTER TABLE agentie_aan
ADD CONSTRAINT pk_agentie_aan PRIMARY KEY(id_agentie);

ALTER TABLE achizitioneaza_aan
ADD CONSTRAINT fk_ac_turist_aan FOREIGN KEY(cod_turist) REFERENCES TURIST(id_turist)
    ON DELETE CASCADE;

ALTER TABLE achizitioneaza_aan
ADD CONSTRAINT fk_ac_excursie_aan FOREIGN KEY(cod_excursie) REFERENCES EXCURSIE(id_excursie)
    ON DELETE CASCADE;

ALTER TABLE excursie_aan
ADD CONSTRAINT fk_ex_agentie_aan FOREIGN KEY(cod_agentie) REFERENCES AGENTIE(id_agentie)
    ON DELETE CASCADE;
    
-- Exercitiul 31
update achizitioneaza_aan
set discount = (select max(discount) from achizitioneaza_aan)
where (
    select pret 
    from excursie_aan
    where id_excursie = cod_excursie
) > (select avg(pret) from excursie_aan);

-- anulam actiunile facute
rollback;

-- Exercitiul 32
desc excursie_aan;
delete from excursie_aan ex1
where ex1.pret < (
    select avg(pret)
    from excursie_aan ex2
    where ex1.cod_agentie = ex2.cod_agentie
);

rollback;

-- Exercitiul 33
alter table excursie_aan
drop constraint fk_ex_agentie_aan;
desc excursie;
select distinct id_excursie  from excursie_aan;
insert into excursie_aan
values(500, 'Meduza Albastra', 5000, 'Africa', 30, 20, 5);
insert into excursie_aan
values(501, 'Meduza Rosie', 5000, 'Africa', 30, 20, 5);

update excursie_aan
set cod_agentie = null
where cod_agentie not in (select cod_agentie
                          from agentie_aan);
                  
rollback;

-- Exercitiul 34
create or replace view v_excursie
as select * from excursie_aan
   where cod_agentie = 10
with check option;

insert into v_excursie
values  (2, 'Ex_test', 100, 'Brasov', 5, 30, 5);

commit;

-- Exercitiul 35
delete from achizitioneaza_aan;
savepoint a;

-- Exercitiul 36
insert into achizitioneaza_aan
select * from achizitioneaza
where to_char(data_achizitie, 'yyyy') = '2010';

update achizitioneaza_aan
set data_start = add_months(data_start, 1), data_end = add_months(data_end, 1);

-- Exercitiul 37
update achizitioneaza_aan
set discount = discount * 1.1
where (
    select cod_agentie
    from excursie_aan
    where cod_excursie = id_excursie
) = 10;

-- Exercitiul 38
delete from achizitioneaza_aan
where (
    select data_nastere
    from turist_aan
    where id_turist = cod_turist
) is null;

-- Exercitiul 39.1
desc achizitioneaza;
merge into achizitioneaza_aan ac1
using achizitioneaza ac2
on (ac1.cod_excursie = ac2.cod_excursie)
when matched then
    update set
    ac1.cod_turist = ac2.cod_turist,
    ac1.data_start = ac2.data_start,
    ac1.data_end = ac2.data_end,
    ac1.data_achizitie = ac2.data_achizitie,
    ac1.discount = ac2.discount
when not matched then
    insert (ac1.cod_excursie, ac1.cod_turist, ac1.data_start, ac1.data_end, ac1.data_achizitie, ac1.discount)
    values (ac2.cod_excursie, ac2.cod_turist, ac2.data_start, ac2.data_end, ac2.data_achizitie, ac2.discount);
;

insert into achizitioneaza_aan
select * from achizitioneaza;

-- Exercitiul 39.2
-- nicio excursie nu a fost achizitionata de mai mult de 2 ori
update excursie_aan
set pret = 0.9 * pret
where id_excursie in (
    select cod_excursie
    from  (
        select cod_excursie, count(1) NrAchizitii
        from achizitioneaza_aan
        group by cod_excursie
    ) ac
    where NrAchizitii = 2
);

-- Exercitiul 40
alter table turist_aan
modify (nume not null);

alter table turist_aan
add unique (nume, prenume);

-- Exercitiul 41
alter table achizitioneaza_aan
add check (data_start < data_end);

alter table achizitioneaza_aan
modify (data_achizitie default sysdate);

-- Exercitiul 42
select *
from achizitioneaza_aan
where data_start <  sysdate
and data_achizitie = (select min(data_achizitie)
                      from achizitioneaza_aan)
for update of data_achizitie;

UPDATE achizitioneaza_aan
SET data_achizitie = DEFAULT
WHERE data_start > sysdate;

commit;

-- Exercitiul 43
-- excursiile achizitionate de Stanciu

with ex_stanciu as (
    select distinct cod_excursie
    from excursie_aan join achizitioneaza_aan on cod_excursie = id_excursie
                      join turist_aan on cod_turist = id_turist
    where upper(nume) = 'STANCIU'
)

select nume, prenume
from turist t
where not exists (
    (
    select cod_excursie
    from ex_stanciu
    )
minus
    (
    select cod_excursie 
    from achizitioneaza_aan
    where cod_turist = t.id_turist
    )
);

-- Exercitiul 44
-- excursiile achizitionate de Stanciu

with ex_stanciu as (
    select distinct cod_excursie
    from excursie_aan join achizitioneaza_aan on cod_excursie = id_excursie
                      join turist_aan on cod_turist = id_turist
    where upper(nume) = 'STANCIU'
)
select nume, prenume
from turist t
where not exists (
    select cod_excursie
    from achizitioneaza_aan
    where cod_turist = t.id_turist and cod_excursie not in (select cod_excursie
                                                            from ex_stanciu)
);

-- Exercitiul 45
select * from achizitioneaza order by cod_turist;
select * from turist order by id_turist;
select * from excursie;
with ex_stanciu as (
    select distinct cod_excursie
    from excursie_aan join achizitioneaza_aan on cod_excursie = id_excursie
                      join turist_aan on cod_turist = id_turist
    where upper(nume) = 'STANCIU'
)
select nume, prenume
from turist_aan
where not exists (
    select cod_excursie
    from achizitioneaza_aan
    where cod_turist = id_turist
    minus
    select cod_excursie
    from ex_stanciu

)
and not exists (
    select cod_excursie
    from ex_stanciu
    minus
    select cod_excursie
    from achizitioneaza_aan
    where cod_turist = id_turist
);

-- Exercitiul 46
accept t_cod prompt "Cod turist= ";
accept t_nume prompt "Nume turist= ";
insert into turist_aan
values(&t_cod, '&t_nume', null, sysdate);
print &t_cod;

define t_cod = 100;
insert into turist_aan
values (&t_cod, '&t_nume', null, sysdate);

-- Exercitiul 47
update turist_aan
set prenume = 'Alexandra'
where id_turist = 100;

select nume, prenume
from turist_aan
where id_turist = 100;

-- Exercitiul 48
delete from turist_aan
where id_turist = 100;

