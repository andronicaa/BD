-- Laborator 7
-- Exercitiul 1
create table emp_aan as select * from employees;
create table dept_aan as select * from departments;

-- Exercitiul 2
desc emp_aan;
desc dept_aan;

-- Exercitiul 3
select * from emp_aan;
select * from dept_aan;

-- Exercitiul 4
alter table emp_aan
add CONSTRAINT pk_emp_aan primary key(employee_id);

alter table dept_aan
add constraint pk_dept_aan primary key(department_id);

alter table emp_aan
add constraint fk_emp_dept_aan
FOREIGN key(department_id) references dept_aan(department_id);


-- Exercitiul 5
-- b si d sunt corecte
insert into dept_aan(department_id, department_name, location_id)
values (300, 'Programare', NULL);
-- Exercitiul 6
insert into emp_aan (employee_id, last_name, email, hire_date, job_id, department_id)
values (207, 'Marcel', 'marcel@email.ro', SYSDATE - 10, 'AD_PRES', 300);
commit;

-- Exercitiul 7 - Tema
insert into emp_aan (employee_id, last_name, email, hire_date, job_id, department_id)
values (235, 'Popescu', 'popescu@yahoo.com', sysdate, 'IT_PROG', 300);

-- Exercitiul 8
insert into emp_aan(employee_id, last_name, email, hire_date, job_id, department_id)
values ((select max(employee_id) + 1 from emp_aan), 'Marcel', 'marcel@email.ro', sysdate - 10, 'AD_PRES', 300);

-- Exercitiul 9 - Tema
CREATE TABLE emp1_aan as (
    select *
    from employees
    where (nvl(commission_pct, 0) > 0.25)
);

-- Exercitiul 10 - Tema
desc employees;
insert into emp_aan(employee_id, first_name, last_name, email, phone_number,hire_date,
              job_id, salary, commission_pct, manager_id, department_id)
values (0, 'Alexandra', 'Andronic', 'TOTAL', 'TOTAL', sysdate, 'TOTAL', 
        (select sum(salary) from emp_aan), (select avg(nvl(commission_pct, 0)) from emp_aan), null, null);

-- Exercitiul 12 - Tema
create table emp2_aan as (select *
                          from employees
                          where 1<>1);
create table emp3_aan as (select *
                          from employees
                          where 1<>1);
insert into emp1_aan
select * 
from employees
where salary < 5000;

insert into emp2_aan
select *
from employees
where salary in (5000, 10000);

insert into emp3_aan
select *
from employees
where salary >= 10000; 

-- stergerea inregistrarilor
truncate table emp1_aan;
truncate table emp2_aan;
truncate table emp3_aan;

-- Exercitiul 13 -  Tema
create table emp0_aan as (select *
                          from employees
                          where 1<>1);

insert into emp0_aan
select *
from employees
where department_id = 80;

insert into emp1_aan
select *
from employees
where salary < = 5000 and department_id <> 80;

insert into emp2_aan
select *
from employees
where salary in (5000, 10000) and department_id <> 80;

insert into emp3_aan
select *
from employees
where salary > 10000 and department_id <> 80;


-- Exercitiul 14
update emp_aan
set salary = salary * 1.05;
--anulam modificarile facute
rollback;

-- Exercitiul 15
update emp_aan
set job_id = 'SA_REP'
where department_id = 80;
rollback;

-- Exercitiul 16 - Tema

update emp_aan
set manager_id = (select employee_id
                  from emp_aan
                  where upper(first_name) = 'DOUGLAS' and upper(last_name) = 'GRANT')
where department_id = 20; 
rollback;

update emp_aan
set salary = salary + 1000
where upper(first_name) = 'DOUGLAS' and upper(last_name) = 'GRANT';

rollback;

-- Exercitiul 17 - tema
update emp_aan
set (salary, commission_pct) = (select salary, commission_pct
                                from emp_aan
                                where employee_id = (select manager_id
                                                     from employees
                                                     where salary = (select min(salary) from employees)))
where employee_id = (select employee_id
                     from employees
                     where salary = (select min(salary) from employees));
rollback;

-- Exercitiul 18 - tema
update emp_aan
set email = substr(last_name, 1, 1) || nvl(first_name, '.')
where salary = (select max(salary)
                from employees e
                where e.department_id = emp_aan.department_id);
rollback;

-- Exercitiul 19 - Tema
update emp_aan
set salary = (select avg(salary) 
              from emp_aan
              where hire_date = (select min(hire_date)
                                 from employees e
                                 where e.department_id = emp_aan.department_id)
);

rollback;

-- Exercitiul 20 - Tema
update emp_aan
set (job_id, department_id) = (select job_id, department_id
                               from employees
                               where department_id = 205)
where department_id = 114;
rollback;

-- Exercitiul 22
-- cele care nu apar in tabelul emp_aan ca si cheie straina
delete from dept_aan;

-- Exercitiul 23
delete from emp_aan
where commission_pct is not null;
rollback;

-- Exercitiul 24 - Tema
delete from dept_aan d
where not exists (select 1
                  from employees e
                  where d.department_id = e.department_id);
                  
rollback;

-- Exercitiul 27 - Tema
savepoint;

-- Exercitiul 28 - Tema
delete from emp_aan;
select * from emp_aan;

-- Exercitiul 29 - Tema
rollback;

-- Exercitiul 30 - Tema
select * from emp_aan;
commit;

