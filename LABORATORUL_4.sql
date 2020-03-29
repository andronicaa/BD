
-- LABORATORUL 4
-- 1
-- a da, in afara de count
-- b in HAVING putem avea comparari cu functii grup
-- iar in where nu putem

-- 2
select max(salary) "Maxim", min(salary) "Minim", sum(salary) "Suma", round(avg(salary), 2) "Media"
from employees;
--where salary > 5000;
-- having round(avg(salary), 2) "Media"

-- 3
select j.job_id, max(salary) "Maxim", min(salary) "Minim", sum(salary) "Suma", round(avg(salary), 2) "Media"
from employees e, jobs j
where e.job_id = j.job_id
group by j.job_id, (min_salary + max_salary) / 2;

-- 4 - TEMA
select employee_id, to_char(salary, '$99,999.00')
from employees;

-- 5 
select count(distinct(manager_id)) "Nr. managere"
from employees;

-- 6 - TEMA

-- 7 
desc locations;
desc departments;
select max(department_name) dep_id, max(location_id) loc_id, count(employee_id) "Nr. ang", round(avg(salary), 2)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id;
--important e cn apare pe primul loc(la noi e department_id)

-- 8 - TEMA

-- 9 
select m.employee_id, min(e.salary) 
from employees e, employees m 
where e.manager_id = m.employee_id
-- and e.manager_id is not null
group by m.employee_id
having min(e.salary) >= 1000
order by 2 desc;

-- 10, 11, 12, 13---- 20, 24, 25- TEMA

-- 21 -- 
select d.department_id, sum(salary)
from employees e, departments d
where e.department_id = d.department_id
and d.department_id <> 30
group by d.department_id -- trebuie sa coincida coloanele dp care grupam
having count(employee_id) > 10
order by 2;




