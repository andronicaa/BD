--LABORATOR 4
--1
--a da, in afara de COUNT
--b In HAVING putem avea comparari cu functii grup, 
--iar in WHERE nu putem
--4: 4, 6, 8, 10-20, 22-25
select department_id, to_char(hire_date, 'yyyy'), sum(salary)
from employees
where department_id > 50
group by rollup (department_id, to_char(hire_date, 'yyyy'));

select department_id, to_char(hire_date, 'yyyy'), sum(salary)
from employees
where department_id < 50
group by cube(department_id, to_char(hire_date, 'yyyy'));

--Exercitiul 2
SELECT MAX(salary) "Maxim", MIN(salary) "Minim", 
       SUM(salary) "Suma",
       ROUND(AVG(salary), 2) "Media"
FROM employees;
--WHERE salary > 5000
--HAVING ROUND(AVG(salary), 2) > 5000;

--Exercitiul 3
SELECT j.job_id, 
       MAX(salary) "Maxim", MIN(salary) "Minim", 
       SUM(salary) "Suma",
       ROUND(AVG(salary), 2) "Media"
       --(min_salary + max_salary)/2
FROM employees e, jobs j
WHERE e.job_id = j.job_id
GROUP BY j.job_id; --, (min_salary + max_salary)/2;

-- Exercitiul 4 - Tema
select job_id, count(employee_id)
from employees
group by job_id;

--Exercitiul 5
SELECT COUNT(DISTINCT manager_id) "Nr.manageri"
FROM employees;

-- Exercitiul 6 - Tema
select max(salary) - min(salary)  "Dif salarii"
from employees;
-- In clauza GROUP BY se trec obligatoriu toate coloanele prezente in clauza
-- SELECt care nu sunt argument al functiilor grup
--Exercitiul 7
DESC departments;
SELECT department_name, location_id, 
    COUNT(employee_id) nr_ang, ROUND(AVG(salary),2) media
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_id, department_name, 
    location_id;
    
--SAU
SELECT MAX(department_name) dept_id, MAX(location_id) loc_id, 
    COUNT(employee_id) nr_ang, ROUND(AVG(salary),2) media
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_id;

-- Exercitiul 8 - Tema
select employee_id, last_name, salary
from employees 
where salary > (select avg(salary)
                from employees)
order by salary desc;


--9
SELECT m.employee_id, MIN(e.salary)
FROM employees e, employees m
WHERE e.manager_id = m.employee_id
--AND e.manager_id IS NOT NULL
GROUP BY m.employee_id
HAVING MIN(e.salary) >= 1000
ORDER BY 2 DESC;

-- Exercitiul 10 - Tema
select e.department_id, department_name, max(salary)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name
having max(salary) > 3000;

-- Exercitiul 11 - Tema
select min(avg(salary))
from employees
group by job_id;

-- Exercitiul 12 - Tema
select e.department_id, department_name, sum(salary)
from employees e join departments d on e.department_id = d.department_id
group by e.department_id, department_name;

-- Exercitiul 13 - Tema
select round(max(avg(salary)), 2)
from employees
group by department_id;

-- Exercitiul 14 - Tema
select e.job_id, job_title, avg(salary)
from employees e join jobs j on e.job_id = j.job_id
group by e.job_id, job_title
having avg(salary) in (select min(avg(salary))
                        from employees e join jobs j
                        on e.job_id = j.job_id
                        group by e.job_id);
                        
-- Exercitiul 15 - Tema
select round(avg(salary), 2)
from employees
having avg(salary) > 2500;

-- Exercitiul 16 - Tema
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
order by department_id;

--sau

select department_id, job_id, sum(salary)
from employees
group by rollup(department_id, job_id);

-- Exercitiul 17 - Tema
 
select department_name, min(salary)
from employees e join departments d on e.department_id = d.department_id
group by department_name
having avg(salary) = (select max(avg(salary))
                      from employees
                      group by department_id);


-- Exercitiul 18 - Tema
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
                            
-- Exercitiul 19 - Tema
select last_name, hire_date
from employees
where hire_date in (select hire_date
                    from employees
                    group by hire_date
                    having count(employee_id) = (select max(count(employee_id))
                                                from employees
                                                group by hire_date));
                                                
-- Exercitiul 20 - Tema 
select count(department_id)
from departments
where department_id in (select e.department_id
                        from departments d join employees e
                        on d.department_id = e.department_id
                        group by e.department_id
                        having count(employee_id) >= 15);

--21
SELECT d.department_id, SUM(salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND d.department_id <> 30
GROUP BY d.department_id
HAVING COUNT(employee_id) > 10
ORDER BY 2;

--22
SELECT d.department_id, MAX(department_name),
    COUNT(employee_id), AVG(salary),
    MAX(last_name), employee_id, MAX(job_id)
FROM employees e, departments d
WHERE e.department_id (+) = d.department_id
GROUP BY d.department_id, employee_id;

-- Exercitiul 23 - Tema
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

-- Exercitiu 24 - Tema
select employee_id
from job_history
group by employee_id
having count(employee_id) >= 2;

-- Exercitiul 25 - Tema

select round(sum(commission_pct) / count(employee_id), 2)
from employees;

--26
--ATENTIE la rollup conteaza ordinea parametrilor, iar
--la cube nu conteaza.
--exemplu ROLLUP
SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY ROLLUP(TO_CHAR(hire_date, 'yyyy'), department_id);

--exemplu CUBE
SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY CUBE(TO_CHAR(hire_date, 'yyyy'), department_id);

--27
SELECT j.job_id job, (SELECT DECODE(d.department_id, 30, SUM(salary))
                      FROM employees
                      WHERE j.job_id = job_id) dep30,
    (SELECT DECODE(d.department_id, 50, SUM(salary))
     FROM employees
     WHERE j.job_id = job_id)dep50,
    (SELECT DECODE(d.department_id, 80, SUM(salary))
     FROM employees
     WHERE j.job_id = job_id) dep80,
    SUM(salary) total
FROM jobs j, departments d, employees e
WHERE j.job_id = e.job_id
AND d.department_id = e.department_id
GROUP BY j.job_id, d.department_id;

-- Exercitiul 28 - Tema
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


SELECT DECODE(department_id, 30, count(employee_id))
FROM employees
group by department_id
having department_id = 30;
--29
SELECT d.department_id, department_name,
    (SELECT COUNT(employee_id)
     FROM employees e1
     WHERE e1.department_id (+) = d.department_id) nr_ang, 
    (SELECT ROUND(AVG(salary), 2)
     FROM employees e1
     WHERE e1.department_id (+) = d.department_id) media_sal,
    last_name, employee_id, job_id
FROM employees e, departments d
WHERE e.department_id (+) = d.department_id; 

--30
SELECT d.department_id, department_name, salariu
FROM departments d, (SELECT SUM(salary) salariu, 
                        em.department_id
                     FROM employees em
                     GROUP BY em.department_id) e
WHERE d.department_id = e.department_id;

-- Exercitiul 31 - Tema
select department_name, salariu
from departments d, (select avg(salary) salariu, e.department_id
                    from employees e
                    group by e.department_id) em
where d.department_id = em.department_id;

-- Exercitiul 32 - Tema
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

-- Exercitiul 33 - Tema

--34


SELECT DISTINCT d.department_id, department_name,
    n.nr, 
    m.med,
    last_name, employee_id, job_id
FROM employees e, departments d,
    (SELECT COUNT(employee_id) nr, e1.department_id department_id
     FROM employees e1
     GROUP BY e1.department_id) n,
    (SELECT ROUND(AVG(salary), 2) med, e1.department_id department_id
     FROM employees e1
     GROUP BY e1.department_id) m
WHERE e.department_id (+) = d.department_id
AND m.department_id (+) = d.department_id
AND n.department_id (+) = d.department_id; 