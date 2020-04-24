-- Laborator 4 Andronic Alexandra

-- Exercitiul 4
select job_id, count(employee_id)
from employees
group by job_id;

-- Exercitiul 6
select max(salary) - min(salary)  "Dif salarii"
from employees;

-- Exercitiul 8
select employee_id, last_name, salary
from employees 
where salary > (select avg(salary)
                from employees)
order by salary desc;

-- Exercitiul 10
select e.department_id, department_name, max(salary)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name
having max(salary) > 3000;

-- Exercitiul 11
select min(avg(salary))
from employees
group by job_id;

-- Exercitiul 12
select e.department_id, department_name, sum(salary)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name;

-- Exercitiul 13
select round(max(avg(salary)), 2)
from employees
group by department_id;

-- Exercitiul 14
select e.job_id, job_title, avg(salary)
from employees e join jobs j on e.job_id = j.job_id
group by e.job_id, job_title
having avg(salary) in (select min(avg(salary))
                        from employees e join jobs j
                        on e.job_id = j.job_id
                        group by e.job_id);
                        
-- Exercitiul 15
select round(avg(salary), 2)
from employees
having avg(salary) > 2500;

-- Exercitiul 16
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
order by department_id;

--sau

select department_id, job_id, sum(salary)
from employees
group by rollup(department_id, job_id);

-- Exercitiul 17
 
select department_name, min(salary)
from employees e join departments d on e.department_id = d.department_id
group by department_name
having avg(salary) = (select max(avg(salary))
                      from employees
                      group by department_id);


-- Exercitiul 18
-- a
select e.department_id, department_name, count(employee_id)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name
having count(employee_id) >  4;

-- b
select e.department_id, department_name, count(employee_id)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name
having count(employee_id) = (select max(count(employee_id))
                            from employees
                            group by department_id);
                            
-- Exercitiul 19
select last_name, hire_date
from employees
where hire_date in (select hire_date
                    from employees
                    group by hire_date
                    having count(employee_id) = (select max(count(employee_id))
                                                from employees
                                                group by hire_date));
                                                
-- Exercitiul 20 
select count(department_id)
from departments
where department_id in (select e.department_id
                        from departments d join employees e
                        on d.department_id = e.department_id
                        group by e.department_id
                        having count(employee_id) >= 15);
                        
-- Exercitiul 23
select e.department_id "Cod dept", sum(salary) "Sum salariu", job_id "Cod job", city, department_name
from employees e join departments d on e.department_id = d.department_id
                join locations l on d.location_id = l.location_id
where e.department_id > 80
group by e.department_id, job_id, city, department_name;

select e.department_id "Cod dept", sum(salary) "Sum salariu", job_id "Cod job", city, department_name
from employees e join departments d on e.department_id = d.department_id
                join locations l on d.location_id = l.location_id
group by e.department_id, job_id, city, department_name
having e.department_id > 80;

-- Exercitiu 24 
select employee_id
from job_history
group by employee_id
having count(employee_id) >= 2;

-- Exercitiul 25

select round(sum(commission_pct) / count(employee_id), 2)
from employees;


-- Exercitiul 28
select distinct (select count(employee_id)
        from employees),  (SELECT sum(DECODE(to_char(hire_date,'yyyy'),'1997', count(employee_id)))
                            FROM employees
                            group by hire_date
                            having to_char(hire_date, 'yyyy') = 1997) "An 1997",
                            (SELECT sum(DECODE(to_char(hire_date, 'yyyy'),'1998', count(employee_id)))
                            FROM employees
                            group by hire_date
                            having to_char(hire_date, 'yyyy') = 1998) "An 1998",
                            (SELECT sum(DECODE(to_char(hire_date, 'yyyy'),'1999', count(employee_id)))
                            FROM employees
                            group by hire_date
                            having to_char(hire_date, 'yyyy') = 1999) "An 1999",
                            (SELECT sum(DECODE(to_char(hire_date, 'yyyy'),'2000', count(employee_id)))
                            FROM employees
                            group by hire_date
                            having to_char(hire_date, 'yyyy') = 2000) "An 2000"

from employees;

-- Exercitiul 31 
select department_name, salariu
from departments d, (select avg(salary) salariu, e.department_id
                    from employees e
                    group by e.department_id) em
where d.department_id = em.department_id;

-- Exercitiul 32
select department_name, e.department_id, salariu, salariati
from departments d, (select avg(salary) salariu,
                     e1.department_id
                     from employees e1
                     group by e1.department_id) e,
                     (select count(employee_id) salariati,
                     e2.department_id
                     from employees e2
                     group by e2.department_id) e3
                     
where d.department_id = e.department_id
and d.department_id = e3.department_id;

-- Exercitiul 33
select last_name, department_name, salary
from employees e join departments d
on e.department_id = d.department_id
where (salary, department_name) in (select min(salary), department_name
                                    from employees e join departments d on e.department_id = d.department_id
                                    group by department_name)
order by department_name;
