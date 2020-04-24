-- Tema din Laboratul 3 Andronic Alexandra

-- Exercitiul 1 - alta varianta
select e1.last_name, TO_CHAR(e1.hire_date, 'MONTH-YYYY') luna_an
from employees e1 join employees e2 on e1.department_id = e2.department_id
where INITCAP(e2.last_name) = 'Gates'
and lower(e1.last_name) LIKE('%a%')
and INITCAP(e1.last_name) <> 'Gates';

-- Exercitiul 4
select d.department_id, department_name, last_name, job_id, '$' ||  to_char(e.salary,'99999.99') 
from employees e join departments d on e.department_id = d.department_id
where upper(department_name) like('%TI%')
order by department_name, last_name;

-- Exercitiul 5
select last_name, e.department_id, department_name, city, job_id
from employees e join departments d on e.department_id = d.department_id
                    join locations l on d.location_id = l.location_id
where initcap(city) = 'Oxford';

-- Exercitiul 8
-- Varianta a
select department_name, salary, last_name
from departments d left join employees e on e.department_id = d.department_id;
-- Varianta b
select department_name, salary, last_name
from departments d, employees e
where d.department_id = e.department_id (+);


-- Exercitiul 12
select department_name 
from departments d
minus 
select department_name
from departments d join employees e
on e.department_id = d.department_id;

-- Exercitiul 17
select last_name, salary, manager_id
from employees
where manager_id = (select employee_id
                    from employees
                    where manager_id  is null);
 
-- Exercitiul 18
select last_name, department_id, salary
from employees
where (department_id, salary) in (
    select department_id, salary
    from employees
    where commission_pct is not null);
    
    
--Exercitiul 20
select last_name, salary
from employees
where salary > all(select salary
                    from employees
                    where upper(job_id) like('%CLERK%'))
order by salary desc;

--Exercitiul 22
select last_name, department_id, salary, job_id
from employees
where (salary, commission_pct) in (select salary, commission_pct
                                    from employees
                                    where department_id = (
                                        select department_id
                                        from departments d join locations l on d.location_id = l.location_id
                                        where initcap(city) = 'Oxford'));
                                        
--Exercitiul 23
select last_name, department_id, job_id
from employees
where department_id = (select department_id
                        from departments d join locations l on d.location_id = l.location_id
                        where initcap(city) = 'Toronto');