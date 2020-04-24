--Laborator 2


--Exercitiul 1
SELECT last_name || ' ' || first_name || ' castiga ' || salary || ' lunar dar doreste ' || salary * 3 "Salariu ideal" 
FROM employees;

--Exercitiul 2
SELECT INITCAP(last_name) prenume,
        UPPER(first_name) nume,
        LENGTH(first_name) lungime
FROM employees
WHERE UPPER(first_name) LIKE('J%')
OR UPPER(first_name) LIKE('M%')
OR UPPER(first_name) LIKE('__A%')
ORDER BY lungime DESC;

--Exercitiul 3

SELECT last_name, employee_id, first_name, department_id
FROM employees
WHERE INITCAP(TRIM(BOTH FROM first_name)) = 'Steven';

--Exercitiul 4 - TEMA
SELECT employee_id "Cod angajat", last_name "Nume angajat", LENGTH(last_name) "Lungime nume angajat",  INSTR(lower(last_name), 'a') "Pozitie"
FROM employees
WHERE LOWER(last_name) LIKE('%e');

--TEMA - 4, 7, 9, 11, 13, 14, 15

--Exercitiul 5
SELECT *
FROM employees
WHERE MOD(ROUND(SYSDATE - hire_date), 7) = 0 ;

--Exercitiul 6
SELECT employee_id, last_name, TRUNC(salary * 1.15, 2) "Salariu nou",
    ROUND(TRUNC(salary * 1.15, 2)/100,2) "Numar sute"
FROM employees
WHERE MOD(salary, 1000) <> 0;

--Exercitiul 7 - TEMA
SELECT last_name "Nume angajat", hire_date "Data angajarii"
FROM employees
WHERE commission_pct <> 0;

--8
SELECT TO_CHAR(SYSDATE + 30, 'MONTH-DAY-YYYY HH24:MI:SS') data_peste_30_de_zile
FROM dual;


--9 - TEMA
SELECT TO_DATE('30-DEC-2020', 'dd-mon-yyyy')  - SYSDATE
FROM dual;


--Exercitiul 10
SELECT TO_CHAR(SYSDATE + 5/1444, 'DD.MM.YYYY HH24:MI:SS')
FROM dual;



--11 - TEMA
SELECT last_name || ' ' || first_name nume_angajat ,
    hire_date, NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Monday') "Negociere"
FROM employees;

--12
SELECT last_name, CEIL(MONTHS_BETWEEN(SYSDATE, hire_date)) "Luni lucrate"
FROM employees
ORDER BY "Luni lucrate"

SELECT UID, USER
FROM dual

SELECT VSIZE(salary)
FROM employees
WHERE employee_id = 200;

--Exercitiul 13 - TEMA
SELECT last_name, hire_date, TO_CHAR(hire_date, 'DAY') Zi
FROM employees
ORDER BY MOD(TO_CHAR(hire_date, 'd') + 5, 7);

--Exercitiul 14 - TEMA
SELECT last_name, DECODE(commission_pct,NULL, 'Fara comision', commission_pct) "Comision"
FROM employees;

--Exercitiul 15 - TEMA
SELECT last_name, salary, commission_pct
FROM employees
WHERE salary > 10000;


--16
SELECT last_name, job_id, salary,
    CASE job_id
        WHEN 'IT_PROG' THEN salary * 1.2
        WHEN 'SA_REP' THEN salary * 1.25
        WHEN 'IT_MAN' THEN salary * 1.35
        ELSE salary
    END "Salariu negociat"
FROM employees;

SELECT last_name, job_id, salary,
    DECODE(job_id, 'IT_PROG', salary * 1.2, 
                    'SA_REP', salary * 1.25,
                    'IR_MAN', salary * 1.35, salary) "Salariu negociat"
FROM employees;

--numarul de angajati 
SELECT COUNT(*)
FROM employees;

--numarul de angajati pe depart
SELECT department_id, COUNT(employee_id)
FROM employees
GROUP BY department_id;

--17
SELECT last_name, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

--varianta standard
SELECT last_name, d.department_id, department_name
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id;

--18
SELECT DISTINCT d.department_id, j.job_id, job_title
FROM employees e JOIN departments d ON e.department_id = d.department_id
                                JOIN jobs j ON j.job_id = e.job_id
WHERE d.department_id = 30;

---TEMA 3
--19 --TEMA
SELECT last_name, department_name, d.location_id, d.department_id, commission_pct, city
FROM employees e JOIN departments d ON e.department_id = d.department_id
                        join locations l on l.location_id = d.location_id
where commission_pct is not null;


-- 20, 21, 22, 23 -- TEMA

-- Exercitiul 20 - TEMA
SELECT last_name, department_name, d.department_id
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE UPPER(last_name) LIKE('%A%');

--Exercitiul  21 - TEMA

select last_name, job_id, d.department_id, department_name, city
from employees e join departments d on e.department_id = d.department_id
                    join locations l on l.location_id = d.location_id
where initcap(city) = 'Oxford';

--Exercitiul 22 - TEMA 
select e1.employee_id "Cod_Angajat", e1.last_name "Angajat", e2.manager_id "Cod_Manager", e2.last_name "Nume_manager" 
from employees e1 join employees e2 on e1.manager_id = e2.employee_id;
select *
from employees;


--Exercitiul 23 - TEMA

select e1.employee_id "Cod_Angajat", e1.last_name "Angajat", e2.manager_id "Cod_Manager", e2.last_name "Nume_manager" 
from employees e1 right join employees e2 on e1.manager_id = e2.employee_id;

SELECT e1.employee_id "Ang#", e1.last_name "Ang", e2.employee_id "Mgr#", e2.last_name "Manager"
FROM employees e1 ,employees e2
WHERE e1.manager_id = e2.employee_id(+);



--24
SELECT e1.employee_id, e1.last_name, e1.department_id, 
            e2.employee_id
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id
AND e1.employee_id <> e2.employee_id;

--25
DESC jobs;
SELECT last_name, j.job_id, job_title, department_name, salary
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id (+)
AND j.job_id = e.job_id;

SELECT DISTINCT job_title, last_name
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

SELECT grade_level
FROM job_grades;

--26
SELECT *
FROM employees
WHERE UPPER(last_name) = 'GATES';

SELECT e1.last_name, e1.hire_date
FROM employees e1, employees e2
WHERE UPPER(e2.last_name) = 'GATES'
AND e1.hire_date > e2.hire_date;

SELECT e1.last_name, e1.ire_date
FROM employees e1 JOIN employees e2 ON e1.hire_date > e2.hire_date
WHERE UPPER(e2.last_name) = 'GATES'
ORDER BY e1.hire_date;

--27 -- TEMA

SELECT e1.last_name "Ang", e1.hire_date "Data_ang", e2.last_name "Manager", e2.hire_date "Data_mng"
FROM employees e1 ,employees e2
WHERE e1.manager_id = e2.employee_id AND e1.hire_date < e2.hire_date;



