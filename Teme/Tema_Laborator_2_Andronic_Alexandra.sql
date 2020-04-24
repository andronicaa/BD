
-- Tema din Laboratorul_2_Andronic_Alexandra

--Exercitiul 4 - TEMA
SELECT employee_id "Cod angajat", last_name "Nume angajat", LENGTH(last_name) "Lungime nume angajat",  INSTR(last_name, 'a') "Pozitie"
FROM employees
WHERE LOWER(last_name) LIKE('%e');

--Exercitiul 7 - TEMA
SELECT last_name "Nume angajat", hire_date "Data angajarii"
FROM employees
WHERE commission_pct <> 0;

--exercitiul 9 - TEMA
SELECT ROUND(TO_DATE('30-DEC-2020', 'dd-mon-yyyy')  - SYSDATE)
FROM dual;

--Exercitiul 11 - TEMA
SELECT last_name || ' ' || first_name nume_angajat ,
    hire_date, NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Monday') "Negociere"
FROM employees;

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





-- Laborator 2 - exercitii ramase Andronic_Alexandra

--Exercitiul 19
select last_name, department_name, d.location_id, d.department_id, commission_pct, city
from employees e join departments d on e.department_id = d.department_id
                        join locations l on l.location_id = d.location_id
where commission_pct is not null;

-- Exercitiul 20
select last_name, department_name, d.department_id
from employees e join departments d on e.department_id = d.department_id
where upper(last_name) like('%A%');

--Exercitiul  21

select last_name, job_id, d.department_id, department_name, city
from employees e join departments d on e.department_id = d.department_id
                    join locations l on l.location_id = d.location_id
where initcap(city) = 'Oxford';

--Exercitiul 22 
select e1.employee_id "Cod_Angajat", e1.last_name "Angajat", e2.manager_id "Cod_Manager", e2.last_name "Nume_manager" 
from employees e1 join employees e2 on e1.manager_id = e2.employee_id;



--Exercitiul 23

select e1.employee_id "Cod_Angajat", e1.last_name "Angajat", e2.manager_id "Cod_Manager", e2.last_name "Nume_manager" 
from employees e1 right join employees e2 on e1.manager_id = e2.employee_id;

select e1.employee_id "Ang#", e1.last_name "Ang", e2.employee_id "Mgr#", e2.last_name "Manager"
from employees e1 ,employees e2
where e1.manager_id = e2.employee_id(+);


--Exercitiul 27

select e1.last_name "Ang", e1.hire_date "Data_ang", e2.last_name "Manager", e2.hire_date "Data_mng"
from employees e1 ,employees e2
where e1.manager_id = e2.employee_id and e1.hire_date < e2.hire_date;