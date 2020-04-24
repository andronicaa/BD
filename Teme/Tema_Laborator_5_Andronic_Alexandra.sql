-- Laborator 5 Andronic Alexandra

-- Exercitiul 2
-- a
select department_name,  job_title, round(avg(salary), 2) "Media salariilor"
from employees e join departments d on e.department_id = d.department_id
                 join jobs j on e.job_id = j.job_id
group by cube(department_name, job_title);

-- b
select department_name,  job_title, round(avg(salary), 2) "Media salariilor",
        decode(grouping(department_name), 1, 'Dep'),
        decode(grouping (job_title), 1, 'Job')
from employees e join departments d on e.department_id = d.department_id
                 join jobs j on e.job_id = j.job_id
group by cube(department_name, job_title);

-- Exercitiul 3
select department_name, job_title, e.manager_id, min(salary), max(salary)
from employees e join departments d on e.department_id = d.department_id
                 join jobs j on e.job_id = j.job_id
group by rollup(department_name, job_title, e.manager_id);

-- Exercitiul 6
-- varianta 1
select last_name || ' ' || first_name, salary
from employees
where salary > all (select round(avg(salary), 2)
                from employees
                group by department_id);
-- varianta 2
select last_name, salary
from employees
where salary > (select max(avg(salary))
                from employees
                group by department_id);
                
-- Exercitiul 7

-- varianta 1 - subcerere sincronizata
select department_id, last_name
from employees e
where salary in (select  min(salary)
                from employees e1
                where e1.department_id = e.department_id
                group by department_id)

group by department_id, last_name
order by department_id;

-- varianta 2 - subcerere nesincronizata
select last_name, department_name, salary
from employees e join departments d
on e.department_id = d.department_id
where (salary, department_name) in (select min(salary), department_name
                                    from employees e join departments d
                                    on e.department_id = d.department_id
                                    group by department_name)
order by department_name;


-- Exercitiul 8
select last_name, department_name, to_char(hire_date, 'dd-mm-yyyy')
from employees e join departments d
on e.department_id = d.department_id
where (to_char(hire_date, 'dd-mm-yyyy'), department_name) in (select min(to_char(hire_date, 'dd-mm-yyyy')), department_name
                                    from employees e join departments d
                                    on e.department_id = d.department_id
                                    group by department_name);
                                    
                                    
-- Exercitiul 10

with emp_desc as (
    select last_name, salary
    from employees
    order by salary desc
)
select *
from emp_desc
where rownum <= 3;

-- Exercitiul 11

select e2.employee_id, e2.last_name, e2.first_name
from employees e1 join employees e2 on e1.manager_id = e2.employee_id
group by e2.employee_id, e2.last_name, e2.first_name
having count(e1.employee_id) >= 2;



-- Exercitiul 12

select count(department_name), city
from departments d join locations l on d.location_id = l.location_id
group by l.location_id, city
having count(department_name) >= 1;

-- Exercitiul 13

select e.department_id, department_name
from employees e join departments d on e.department_id = d.department_id
where exists (select department_id
                           from employees
                           group by department_id)
group by e.department_id, department_name;


-- Exercitiul 15
select manager_id, employee_id
from employees 
start with manager_id = (select employee_id
                         from employees
                         where employee_id = 114)
connect by prior employee_id = manager_id; 


-- Exercitiul 17
select employee_id, manager_id, level
from employees
start with manager_id is null
connect by prior employee_id = manager_id;

-- Exercitiul 18
select employee_id, manager_id, level
from employees
where salary >= 5000
start with manager_id = (
    select employee_id
    from employees
    where salary = (
        select max(salary)
        from employees
    )
)
connect by prior employee_id = manager_id
order by employee_id;

-- Exercitiul 22

with emp_desc as (
    select last_name, salary
    from employees
    order by salary
)
select *
from emp_desc
where rownum <= 3;

-- Exercitiul 25
select last_name,decode(to_char(hire_date, 'yyyy'), '1989', salary * 1.2, '1990', salary * 1.15, '1991', salary * 1.1, salary) "Salariu"
from employees;
