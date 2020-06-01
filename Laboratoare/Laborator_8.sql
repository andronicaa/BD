-- Laboratorul 8

-- Exercitiul 1
-- a
create table angajati_aan (
    cod_ang number(4),
    nume varchar2(20),
    prenume varchar2(20),
    email char(15),
    data_ang date,
    job varchar2(10),
    cod_sef number(4),
    salariu number(8, 2),
    cod_dep number(2)
);

-- b
drop table angajati_aan;
create table angajati_aan (
    cod_ang number(4) primary key,
    nume varchar2(20) not null,
    prenume varchar2(20),
    email char(15),
    data_ang date default sysdate,
    job varchar2(10),
    cod_sef number(4),
    salariu number(8, 2) not null,
    cod_dep number(2)
);
desc angajati_aan;

-- c
drop table angajati_aan;


CREATE TABLE angajati_aan (
    cod_ang NUMBER(4),
    nume VARCHAR2(20) NOT NULL,
    prenume VARCHAR2(20), 
    email CHAR(15),
    data_ang DATE DEFAULT SYSDATE,
    job VARCHAR2(10),
    cod_sef NUMBER(4),
    salariu NUMBER(8,2) NOT NULL,
    cod_dep NUMBER(2),
    PRIMARY KEY(cod_ang)
);

-- Exercitiul 2

INSERT INTO angajati_aan (cod_ang, nume, prenume, 
                          job, salariu, cod_dep)
VALUES ( 100, 'Nume1', 'Prenume1', 'Director', 20000, 10);


INSERT INTO angajati_aan
VALUES ( 101, 'Nume2', 'Prenume2', 'Nume2', TO_DATE('02-02-2004', 'DD-MM-YYYY'), 'Inginer',
    100, 10000, 10);

INSERT INTO angajati_aan
VALUES ( 102, 'Nume3', 'Prenume2', 'Nume3',
    TO_DATE('05-06-2000', 'DD-MM-YYYY'), 'Analist', 
    101, 5000, 20);

INSERT INTO angajati_aan (cod_ang, nume, prenume, 
                          job, cod_sef, salariu, 
                          cod_dep)
VALUES ( 103, 'Nume4', 'Prenume4', 
    'Inginer', 100, 9000, 20);

INSERT INTO angajati_aan
VALUES ( 104, 'Nume5', 'Prenume5', 'Nume5',
    NULL, 'Analist', 
    101, 3000, 30);

select * from angajati_aan;
UPDATE angajati_aan
SET data_ang = NULL
WHERE cod_ang IN (100,103);

select *
from angajati_aan;

-- Exercitiu; 3 - Tema
drop table angajati10_aan;
create table angajati10_aan as (select *
                                from angajati_aan
                                where cod_dep = 10);
select * from angajati10_aan;

-- Exercitiul 4
-- adaugam o coloana noua
alter table angajati_aan
add comision number(4, 2);

-- Exercitiul 5
-- Nu se poate modifica tipul coloanei deoarece nu contine doar date null

-- Exercitiul 6
alter table angajati_aan
modify salariu number(8,2) default 0;

-- Exercitiul 7
alter table angajati_aan
modify (comision number(2, 2), salariu number(10, 2));

-- Exercitiul 8
update angajati_aan
set comision = 0.1
where upper(job) like 'A%';

-- Exercitiul 9 - Tema
alter table angajati_aan
modify (email varchar2(50));


-- Exercitiul 10 - Tema
alter table angajati_aan
add (nr_telefon varchar2(11) default '0754623152');


-- Exercitiul 11 - Tema
select * from angajati_aan;

alter table angajati_aan
drop column nr_telefon;

-- Exercitiul 12
rename angajati_aan to angajati3_aan;

-- Exercitiul 13
select * from tab;

rename angajati3_aan to angajati_aan;

-- Exercitiul 14
truncate table angajati10_aan;
select * from angajati10_aan;

-- Exercitiul 15 - Tema

create table departamente_aan (
    cod_dep NUMBER(2),
    nume VARCHAR2(15) NOT NULL,
    cod_director NUMBER(4)
);
select * from departamente_aan;
desc departamente_aan;

-- Exercitiul 16 - Tema
insert into departamente_aan
columns (cod_dep, nume, cod_director)
values (10, 'administrativ', 100);

insert into departamente_aan
columns (cod_dep, nume, cod_director)
values (20, 'proiectare', 101);

insert into departamente_aan
columns (cod_dep, nume, cod_director)
values (30, 'programare', null);

select * from departamente_aan;

-- Exercitiul 17 - Tema
alter table departamente_aan
add primary key(cod_dep);

-- Exercitiul 18 - Tema
-- a
select * from angajati_aan;
alter table angajati_aan
add foreign key(cod_dep) references departamente_aan(cod_dep);

--b 
-- 2 in 1
drop table angajati_aan;
desc departamente_aan;
create table angajati_aan (
    cod_ang NUMBER(4) primary key,
    nume VARCHAR2(20) NOT NULL,
    prenume VARCHAR2(20), 
    email CHAR(15) unique,
    data_ang DATE DEFAULT SYSDATE,
    job VARCHAR2(10),
    cod_sef NUMBER(4),
    comision number(2, 2),
    salariu NUMBER(8, 2) not null,
    cod_dep NUMBER(3),
    foreign key(cod_sef) references angajati_aan(cod_ang),
    check (cod_dep > 0),
    check (salariu > comision * 100),
    constraint ANG unique (nume, prenume)
    
);




-- Exercitiul 22

desc user_tables;
desc tab;
desc user_constraints;
select * from tab;

-- Exercitiul 23
-- a
select constraint_name, constraint_type, table_name
from user_constraints
where lower(table_name) in ('angajati_aan', 'departament_aan');

-- b
select table_name, constraint_name, column_name
from user_cons_columns
where lower(table_name) in ('angajati_aan', 'departamente_aan');

-- Exercitiul 24

select *
from angajati_aan;

update angajati_aan
set email = 'email@email.com'
where email is null;

alter table angajati_aan
modify (email varchar2(50) not null);


-- Exercitiul 25 
-- Nu se poate pentru ca nu exista departamentul 50(da eroare)

-- Exercitiul 26
select *
from departamente_aan;

insert into departamente_aan
columns (cod_dep, nume, cod_director)
values (60, 'Analiza', null);



commit;

-- Exercitiul 27
select * from departamente_aan;
select * from angajati_aan;
delete from departamente_aan
where cod_dep = 20;
-- s-a sters departamentul 20

-- Exercitiul 28
delete from departamente_aan
where cod_dep = 60;
rollback;

-- Exercitiul 29
-- Nu se poate adauga deoarece nu exista angajatul cu codul 114
insert into angajati_aan
columns (cod_ang, nume, prenume, email, job, cod_dep, cod_sef)
values (110, 'Nume6', 'Prenume6', 'Nume6', 'Tester', 60, 114);

-- Exercitiul 30
insert into angajati_aan
columns (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, comision, cod_dep)
values (114, 'Andronic', 'Alexandra', 'alexandra@email.com', sysdate, 'it', null, 100, 0.2, 60);

insert into angajati_aan
columns (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, comision, cod_dep)
values (110, 'Andronic1', 'Alexandr1', 'alexandr1a@email.com', sysdate, 'it', 114, 100, 0.2, 60);


-- Exercitiul 31

select * from user_constraints
where lower(table_name) = 'angajati_aan';
desc departamente_aan;
rollback;
desc angajati_aan;
select * from angajati_aan;
alter table angajati_aan
drop constraint SYS_C00353782;

alter table angajati_aan
add foreign key(cod_dep) references departamente_aan(cod_dep) on delete cascade;

-- Exercitiul 32
select * from departamente_aan;


insert into angajati_aan
columns (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, comision, cod_dep)
values (113, 'Andronic2', 'Alexandr2', 'alexandr2a@email.com', sysdate, 'it', 114, 100, 0.2, 20);

delete from departamente_aan
where cod_dep = 20;
select * from angajati_aan;

-- Exercitiul 33
desc departamente_aan;
insert into angajati_aan
columns (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, comision, cod_dep)
values (100, 'Andronic3', 'Alexandr3', 'alexandr3a@email.com', sysdate, 'it', 114, 100, 0.2, 10);

alter table departamente_aan
add foreign key(cod_director) references angajati_aan(cod_ang) on delete set null;

-- Exercitiul 34
insert into angajati_aan
columns (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, comision, cod_dep)
values (102, 'Andronic4', 'Alexandr4', 'alexandr4a@email.com', sysdate, 'it', 114, 100, 0.2, 10);

select * from angajati_aan;
update departamente_aan
set cod_director = 102
where cod_dep = 30;

delete angajati_aan
where cod_ang = 102;
rollback;
select * from angajati_aan;
select * from departamente_aan;

-- Exercitiul 35
alter table angajati_aan
add check (salariu < 30000);

-- Exercitiul 36
update angajati_aan
set salariu = 35000
where cod_ang = 100;
-- nu functioneaza deoarece am adaugat constrangerea check la ex 35 check constraint (GRUPA31.SYS_C00353803) violated
-- Exercitiul 37
alter table angajati_aan
drop constraint SYS_C00353803;
-- acum merge 

