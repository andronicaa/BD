--1
SELECT e1.last_name, TO_CHAR(e1.hire_date, 'MONTH-YYYY') luna_an
FROM employees e1 JOIN employees e2
    USING(department_id)
WHERE INITCAP(e2.last_name) = 'Gates'
AND LOWER(e1.last_name) LIKE('%a%');

--2
SELECT DISTINCT e1.employee_id, e1.last_name
FROM employees e1 JOIN employees e2
    ON e1.department_id = e2.department_id
    AND e1.employee_id <> e2.employee_id
WHERE UPPER(e2.last_name) LIKE('%T%')
ORDER BY last_name;

--3
SELECT e1.last_name, e1.salary, job_title, city, country_name
FROM employees e1, employees e2, departments d, locations l, countries c, jobs j
WHERE e1.manager_id = e2.employee_id
AND INITCAP(e2.last_name) = 'King'
AND e1.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id
AND j.job_id = e1.job_id;


---6
SELECT DISTINCT e1.employee_id, e1.last_name, e1.salary
FROM employees e1 JOIN employees e2
    ON e1.department_id = e2.department_id
    AND e1.employee_id <> e2.employee_id
WHERE UPPER(e2.last_name) LIKE('%T%')
AND e1.salary > (SELECT AVG(e3.salary)
                FROM employees e3
                WHERE e1.job_id = e3.job_id);

---7
SELECT last_name, department_name
FROM departments d RIGHT OUTER JOIN employees e1
ON (d.department_id = e1.department_id );

SELECT last_name, department_name
FROM departments d,employees e1
WHERE (d.department_id (+)= e1.department_id );

---9
SELECT last_name, department_name
FROM employees e1, departments d
WHERE d.department_id (+) = e1.department_id
UNION
SELECT last_name, department_name
FROM employees ...(de completat);


--10
select distinct e.department_id
from employees e, departments d
where e.department_id = d.department_id
and upper(d.department_name) like '%RE%'
    or upper(job_id) = 'SA_REP';
    

select e.department_id
from employees e, departments d
where e.department_id = d.department_id
and upper(d.department_name) like '%RE%'
union all--se face automat si dinstinct pe cereri
select e.department_id
from employees e, departments d
where e.department_id = d.department_id
    and upper(job_id) = 'SA_REP';
    
--    11 apare rezultatul cu duplicate
-- 12 TEMA
-- 13 - se foloseste intersect (deoarece este "si")
select e.department_id
from employees e, departments d
where e.department_id = d.department_id
and upper(d.department_name) like '%RE%'
intersect
select e.department_id
from employees e, departments d
where e.department_id = d.department_id
and upper(job_id) = 'HR_REP';

--14
desc jobs;
select employee_id, job_id, last_name
from employees
where salary > 3000
union
select e.employee_id, j.job_id, last_name
from employees e, jobs j
where e.job_id = j.job_id
and salary = (min_salary + max_salary) / 2;

--subcereri
--15
select last_name, hire_date
from employees
where hire_date > (select hire_date
                    from employees
                    where upper(last_name) = 'GATES');
-- trebuie ca cererea din subcerere sa returneze un singur lucru

-- 16
select last_name, salary
from employees e
where employee_id not in (select employee_id
                            from employees
                            where initcap(last_name) = 'Gates' and e.department_id = department_id)
order by 1; --ordoneaza dupa prima coloana
 --daca subcererea returneaza mai mult de o linie atunci nu putem folosi =, altfel putem folosi amblele variante
 
 -- 17 - TEMA
 -- 18 - TEMA
 -- 20, 22, 23 - TEMA
-- 21 
select e.department_id, department_name, salary
from employees e, departments d
where e.department_id = d.department_id
    and commission_pct is null
    and e.manager_id =any (select manager_id 
                        from employees
                        where manager_id = e.manager_id
                        and commission_pct is not null);
-- se poate folosi si IN in loc de =any


