
--Laborator 5
--exercitii
--1
--a
SELECT department_name, job_title, 
    ROUND(AVG(salary), 2) media
FROM departments d, jobs j, employees e
WHERE d.department_id = e.department_id
AND j.job_id = e.job_id
GROUP BY ROLLUP(d.department_id, j.job_id), 
    department_name, job_title;
    
select department_name, job_title, round(avg(salary), 2)
from employees e join departments d on e.department_id = d.department_id
                 join jobs j on e.job_id = j.job_id
group by rollup(d.department_name, j.job_title);

--b
SELECT department_name, job_title, 
    ROUND(AVG(salary), 2) media,
    GROUPING(department_name) dep, 
    GROUPING(job_title) job
FROM departments d, jobs j, employees e
WHERE d.department_id = e.department_id
AND j.job_id = e.job_id
GROUP BY ROLLUP(d.department_name, j.job_title);

-- Exercitiul 2 - Tema
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

-- Exercitiul 3 - Tema
select department_name, job_title, e.manager_id, min(salary), max(salary)
from employees e join departments d on e.department_id = d.department_id
                 join jobs j on e.job_id = j.job_id
group by rollup(department_name, job_title, e.manager_id);

--4
SELECT MAX(salary)
FROM employees
HAVING MAX(salary) > 15000;

--5
--a
SELECT last_name, salary
FROM employees e
WHERE salary > (SELECT AVG(salary)
                FROM employees e1
                WHERE e1.department_id = e.department_id
                AND e1.employee_id <> e.employee_id);

--b
--subcerere necorelata in from
SELECT department_name, em.medie, em.nr_ang
FROM departments d, (SELECT ROUND(AVG(salary), 2) medie,  
                     COUNT(employee_id) nr_ang,
                     e.department_id
                     FROM employees e
                     GROUP BY e.department_id) em
WHERE d.department_id = em.department_id;
       
--subcerere corelata in select
SELECT department_name, 
    (SELECT COUNT(employee_id)
     FROM employees e
     WHERE e.department_id = d.department_id) s1,
    (SELECT ROUND(AVG(salary), 2)  
     FROM employees e
     WHERE e.department_id = d.department_id) s2
FROM departments d;   

-- Exercitiul 6 - Tema
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
                
-- Exercitiul 7 - Tema

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
-- varianta 3 - subcerere in from




-- Exercitiul 8 - Tema
select last_name, department_name, to_char(hire_date, 'dd-mm-yyyy')
from employees e join departments d
on e.department_id = d.department_id
where (to_char(hire_date, 'dd-mm-yyyy'), department_name) in (select min(to_char(hire_date, 'dd-mm-yyyy')), department_name
                                    from employees e join departments d
                                    on e.department_id = d.department_id
                                    group by department_name);

--9
SELECT last_name, department_id
FROM employees e3
WHERE EXISTS(SELECT 1
             FROM employees e1
             WHERE e1.salary = (SELECT MAX(e2.salary)
                                FROM employees e2
                                WHERE e2.department_id = 30)
             AND e1.department_id = e3.department_id);
             
-- Exercitiul 10 - Tema

WITH emp_desc AS (
    SELECT last_name, salary
    FROM employees
    ORDER BY salary desc
)
SELECT *
FROM emp_desc
WHERE ROWNUM <= 3;

-- Exercitiul 11 - Tema

SELECT e2.employee_id, e2.last_name, e2.first_name
FROM employees e1 INNER JOIN employees e2 ON e1.manager_id = e2.employee_id
GROUP BY e2.employee_id, e2.last_name, e2.first_name
HAVING COUNT(e1.employee_id) >= 2;



-- Exercitiul 12 - Tema

select count(department_name), city
from departments d join locations l on d.location_id = l.location_id
group by l.location_id, city
having count(department_name) >= 1;

-- Exercitiul 13 - Tema

select e.department_id, department_name
from employees e join departments d on e.department_id = d.department_id
where exists (select department_id
                           from employees
                           group by department_id)
group by e.department_id, department_name;
--14
--a
SELECT employee_id, last_name, hire_date, salary, manager_id
FROM employees
WHERE manager_id = (SELECT employee_id
                    FROM employees
                    WHERE UPPER(last_name) = 'DE HAAN');

--b
SELECT employee_id, last_name, hire_date, salary, manager_id
FROM employees
START WITH manager_id = (SELECT employee_id
                         FROM employees
                         WHERE UPPER(last_name) = 'DE HAAN')
CONNECT BY PRIOR employee_id = manager_id;

SELECT employee_id, last_name, hire_date, salary, manager_id
FROM employees
START WITH manager_id = (SELECT employee_id
                         FROM employees
                         WHERE UPPER(last_name) = 'DE HAAN')
CONNECT BY PRIOR manager_id = employee_id;

-- Exercitiul 15 - Tema
select manager_id, employee_id
from employees 
start with manager_id = (select employee_id
                         from employees
                         where employee_id = 114)
connect by prior employee_id = manager_id; 

--16
SELECT employee_id, manager_id, last_name
FROM employees
WHERE LEVEL = 2
START WITH manager_id = (SELECT employee_id
                         FROM employees
                         WHERE UPPER(last_name) = 'DE HAAN')
CONNECT BY PRIOR employee_id = manager_id;
-- Exercitiul 17 - Tema
SELECT employee_id, manager_id, LEVEL
FROM employees
start with manager_id is null
CONNECT BY PRIOR employee_id = manager_id;

-- Exercitiul 18 - Tema
SELECT employee_id, manager_id, LEVEL
FROM employees
WHERE salary >= 5000
START WITH manager_id = (
    SELECT employee_id
    FROM employees
    WHERE salary = (
        SELECT MAX(salary)
        FROM employees
    )
)
CONNECT BY PRIOR employee_id = manager_id
ORDER BY employee_id;
--19
WITH tabel AS (
    SELECT department_name, 
            SUM(salary) sum_sal,
            COUNT(employee_id) nr_ang
    FROM departments d, employees e
    WHERE e.department_id = d.department_id
    GROUP BY e.department_id, department_name
) 
SELECT department_name
FROM tabel
WHERE sum_sal > (SELECT SUM(sum_sal)/SUM(nr_ang)
                 FROM tabel);
                 
--21
--NU ESTE BUN
SELECT employee_id, last_name, salary
FROM employees
WHERE ROWNUM <= 10
ORDER BY salary DESC;

SELECT employee_id, last_name, salary
FROM employees
ORDER BY salary DESC;

--ESTE BUN
WITH emp_desc AS (
    SELECT employee_id, last_name, salary
    FROM employees
    ORDER BY salary DESC
)
SELECT *
FROM emp_desc
WHERE ROWNUM <= 10;

-- Exercitiul 22 - Tema

WITH emp_desc AS (
    SELECT last_name, salary
    FROM employees
    ORDER BY salary
)
SELECT *
FROM emp_desc
WHERE ROWNUM <= 3;

--23
DESC departments;

SELECT 'Departamentul ' || department_name || '
    este condus de ' || 
    NVL(TO_CHAR(d.manager_id), 'nimeni') || 
    ' si ' || CASE COUNT(employee_id)
                    WHEN 0 THEN 'nu are salariati'
                    ELSE 'are numarul de salariati ' 
                        || COUNT(employee_id)
              END info
FROM employees e, departments d
WHERE e.department_id (+) = d.department_id
GROUP BY d.department_id, department_name, 
    d.manager_id;

--24
SELECT last_name, first_name, LENGTH(last_name)
FROM employees
WHERE NULLIF(LENGTH(last_name),LENGTH(first_name)) IS NOT NULL;

-- Exercitiul 25 - Tema
select last_name,decode(to_char(hire_date, 'yyyy'), '1989', salary * 1.2, '1990', salary * 1.15, '1991', salary * 1.1, salary) "Salariu"
from employees;
--26
--persoanele care incep cu s
SELECT last_name, INSTR(UPPER(last_name),'S')
FROM employees;

SELECT j.job_id, 
DECODE(INSTR(UPPER(job_title),'S'), 
    1, '1. ' || SUM(salary), 
    DECODE(MAX(salary), 
           (SELECT MAX(salary)
            FROM employees), '2. ' || AVG(salary),
           '3. ' || MIN(salary)))
FROM employees e, jobs j
WHERE j.job_id = e.job_id
GROUP BY j.job_id, job_title;