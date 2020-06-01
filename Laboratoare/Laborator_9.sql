-- Laborator 9

-- Exercitiul 1
create global temporary table temp_tranz_aan ( x number) on commit delete rows;
insert into temp_tranz_aan
values (10);

select *
from temp_tranz_aan;

commit;

-- Exercitiul 2
create global temporary table temp_sesiune_aan (x number) on commit preserve rows;
insert into temp_sesiune_aan
values(10);

select * from temp_sesiune_aan;
commit;


-- Exercitiul 3
desc temp_tranz_aan;
desc temp_sesiune_aan;

select *  from temp_tranz_aan;
select * from temp_sesiune_aan;

-- Exercitiul 4
truncate table temp_tranz_aan;
truncate table temp_sesiune_aan;

-- Exercitiul 5

create global temporary table angajati_azi_aan (
        first_name varchar2(50), 
        last_name varchar2(50),
        cod_ang number(3));
        
-- nu se aloca spatiu pentru acest tabel deocamdata

-- Exercitiul 6

insert into angajati_azi_aan
values ('Andronic', 'Alexandra', 999);
select * from angajati_azi_aan;
alter table angajati_azi_aan
modify (last_name varchar2(15));


-- Exercitiul 7
select * from angajati_aan;
create or replace view viz_emp30_aan as (
                    select cod_ang, nume, email, salariu, cod_dep
                    from angajati_aan
                    where cod_dep = 30
                    );
                    
select * from viz_emp30_aan;
desc viz_emp30_aan;
insert into viz_emp30_aan
values (1, 'NumeX', 'nume@email.com', 50000, 120);


-- Exercitiul 8
create or replace view viz_emp30_aan as (
        select employee_id, last_name, email, salary, department_id, hire_date, job_id
        from employees
        where department_id = 30
                    );
select * from viz_emp30_aan;
insert into viz_emp30_aan
values (1000, 'Nume1', 'nume1@email.com', 3000, 30, sysdate, 'PU_MAN');


rollback;
-- Exercitiul 9
create view viz_empsal50_aan as (
            select cod_ang AS cod_angajat, nume, email, job AS functie, data_ang AS data_angajare, salariu * 12 AS sal_anual 
            from angajati_aan
            where cod_dep = 50
);
-- nu merge deoarece s-au folosit alias-uri(vizualizari inline)
rollback;
-- Exercitiul 10
-- a
insert into viz_empsal50_aan
values (1001, 'Andronic', 'andronic@andronic.com', 'IT', sysdate, 120);
-- b
insert into viz_empsal50_aan
columns (cod_angajat, nume, email, functie, data_ang)
values (1005, 'Alexandra', 'alexandra@gmail.com', 'vanzator', sysdate);
--nu vrea :( !

-- Exercitiul 11
desc departamente_aan;
-- a
create or replace view viz_emp_dep30_aan as (
    select cod_ang, viz_emp30_aan.nume AS nume, departamente_aan.nume AS nume_departament,
    email, salariu, viz_emp30_aan.cod_dep
    from viz_emp30_aan, departamente_aan
    where departamente_aan.cod_dep = 30
);

-- b

insert into viz_emp_dep30_aan
values (1005, 'Popescu', 'PU_IT', 'pop@email.com', 1253, 23);

-- c
select * from user_updatable_columns
where lower(table_name) = 'viz_emp_dep30_aan';
-- nicio coloana nu poate fi actualizata

-- d
--nu se poate realiza stergerea din tabel (deleteable = NO)

-- Exercitiul 12
CREATE VIEW viz_dept_sum_aan (dept_id, min_sal, max_sal, med_sal)
AS (SELECT department_id, MIN(salary), MAX(salary),
        ROUND(AVG(salary), 2)
    FROM employees
    GROUP BY department_id);

SELECT *
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'VIZ_DEPT_SUM_ASI';


-- Exercitiul 13
select * from viz_emp30_aan;
select * from user_constraints
where lower(table_name) = 'viz_emp30_aan';
create or replace view viz_emp30_aan  as (
    select cod_ang, nume, email, salariu, cod_dep
    from angajati_aan
    where cod_dep = 30
)
with check option constraint viz_check_dep30;
insert into viz_emp30_aan
values (2000, 'Alexandra', 'alexandra@email.com', 125, 30);
-- nu merge

-- Exercitiul 14
-- a
create or replace view viz_emp_s_aan
as (select cod_ang, a.nume, email, salariu,
        d.cod_dep, data_ang, job
    from angajati_aan a join departamente_aan d
    on a.cod_dep = d.cod_dep
    where lower(d.nume) like 's%');

select * from viz_emp_s_aan;
insert into viz_emp_s_aan
values (5000, 'Ion', 'ion@email.com', 512, 20, sysdate, 'maturator');
-- nu se pot adauga linii

-- b ? cu with read only? nu stiu

-- Exercitiul 15
select * from user_views;

-- Exercitiul 16
select * 
from angajati_aan a join viz_dept_sum_aan d on a.cod_dep = d.dept_id; 

-- Exercitiul 17
create or replace view viz_sal_aan as (
    select last_name as nume, department_name as nume_dept, salary as salariu, city as locatie
    from employees e join departments d using(department_id)
                join locations using(location_id)
);

select * from viz_sal_aan;
SELECT *
FROM USER_UPDATABLE_COLUMNS
WHERE lower(TABLE_NAME) = 'viz_sal_aan';
-- salariul si numele sunt actualizabile

-- Exercitiul 18
desc emp_aan;
create or replace view v_emp_aan(
    employee_id,
    last_name,
    first_name,
    email unique disable novalidate,
    phone_number,
    constraint pk_viz_emp_aan primary key(employee_id) disable novalidate
    
) as select employee_id, first_name, last_name, email, phone_number
from emp_aan;

select *  from v_emp_aan;

-- Exercitiul 19
alter view viz_emp_s_aan
add primary key(cod_ang) disable novalidate;

--20
CREATE SEQUENCE seq_dept_aan
START WITH 200
INCREMENT BY 10
MAXVALUE 10000
NOCYCLE
NOCACHE;

-- Exercitiul 22
create sequence seq_emp_aan;
drop sequence seq_emp_aan;

-- Exercitiul 23
drop table emp_aan;
create table emp_aan as (select *  from employees);
update emp_aan
set employee_id = seq_emp_aan.nextval;

select *  from emp_aan;

-- Exercitiul 24
drop table dept_aan;
create table dept_aan as (select *  from departments);
desc emp_aan;
insert into emp_aan 
values (seq_emp_aan.nextval, 'Alexandra', 'Andronica', 'andr@email.com',
  '120256222145', sysdate, 'IT', 125, 0.2, 23, 23);
  
desc dept_aan;
insert into dept_aan
values (seq_dept_aan.nextval, 'pizza', 100, 45);

-- Exercitiul 25
select seq_emp_aan.currval, seq_dept_aan.currval
from dual;

-- Exercitiul 28
create unique index idx_emp_id_aan 
on emp_aan(employee_id);

create unique index idx_comb_id_aan 
on emp_aan(first_name, last_name, hire_date);

alter table emp_aan
add primary key(employee_id) 
add unique (last_name, first_name, hire_date);

--  Exercitiul 29
create index idx_dept_id_aan
on emp_aan(department_id);

-- Exercitiul 30
create index idx_upper_aan
on dept_aan(upper(department_name));

create index idx_lower_aan
on emp_aan(lower(last_name));

-- Exercitiul 31
select index_name, column_name, column_position, uniqueness
from user_indexes join user_ind_columns using(index_name)
where lower(user_indexes.table_name) in ('emp_aan', 'dept_aan');


-- Exercitiul 43
create synonym n30_aan
for viz_emp30_aan;

-- Exercitiul 44
create synonym dept_s_aan for dept_aan;
select * from dept_s_aan;
rename dept_aan to rename_dept_aan;
rename rename_dept_aan to dept_aan;
-- sinonimul nu mai este valid dupa redenumirea tabelului

-- Exercitiul 47
CREATE TABLE job_dep_aan (
 job VARCHAR2(10),
 dep NUMBER(4),
 suma_salarii NUMBER(9,2)); 
drop table job_dep_pnu;

CREATE MATERIALIZED VIEW vm_job_dep_aan
 ON PREBUILT TABLE WITH REDUCED PRECISION
 ENABLE QUERY REWRITE
 AS SELECT d.department_name, j.job_title, SUM(salary) suma_salarii
 FROM employees e, departments d, jobs j
 WHERE e.department_id = d. department_id
 AND e.job_id = j.job_id
 GROUP BY d.department_name, j.job_title; 

-- Exercitiul 48
CREATE MATERIALIZED VIEW LOG ON dept_aan;

CREATE MATERIALIZED VIEW dep_vm_aan
REFRESH FAST START WITH SYSDATE NEXT SYSDATE + 1/288
WITH PRIMARY KEY
AS SELECT * FROM dept_aan;



