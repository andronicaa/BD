-- Tema din Laboratorul_1_Andronic_Alexandra - 14, 18, 20, 22

--Exercitiul 14
SELECT last_name "Angajat", salary "Salariu lunar"
FROM employees
WHERE department_id IN(10,30) AND salary > 3500;

--Exercitiul 18 --TEMA
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct > 0
ORDER BY salary, commission_pct ASC;

--Exercitiul 20 -TEMA
SELECT last_name
FROM employees
WHERE UPPER(last_name) LIKE('__A%');

--Exercitiul 22 - TEMA
SELECT last_name, job_id, salary
FROM employees
WHERE (UPPER(job_id) LIKE('%CLERK%') OR UPPER(job_id) LIKE('%REP%')) AND (salary <> 1000 AND salary <> 2000 AND salary <> 3000);
DESC employees


