DESC employees

--Exercitiul 5
SELECT employee_id, first_name, job_id, hire_date
FROM employees

--Exercitiul 6 -> afiseaza codul job ului fara duplicate 
SELECT DISTINCT job_id
FROM employees

--Exercitiul 7 -- || operator pentru concatenare , "" pentru alias uri
SELECT last_name || ',' || job_id "Anagajat si titlu"
FROM employees

--Exercitiul 8
SELECT first_name || ',' || last_name || ',' || email || ',' || phone_number || ',' || hire_date || ',' || 
            job_id || ',' || salary || ',' || commission_pct || ',' || manager_id || ',' || department_id "Informatii complete"
FROM employees

--Exerctiul 9
SELECT last_name, salary
FROM employees
WHERE salary > 2850

--Exercitiul 10
SELECT last_name, department_id
FROM employees
WHERE employee_id = 104

--Exercitiul 11 -- pentru testarea apartenentei la un domeniu se foloseste [NOT] BETWEEN val_1 AND val_2
SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 1500 AND 2850

--Exercitiul 12
SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN '20-FEB-1987' AND '1-MAY-1989'
ORDER BY hire_date ASC

--Exercitiul 13 --> apartenenta intr-o multime finita de valori se testeaza cu IN
SELECT last_name, department_id
FROM employees
WHERE department_id IN (10,30)
ORDER BY last_name ASC

--Exercitiul 14 - TEMA
SELECT last_name "Angajat", salary "Salariu lunar"
FROM employees
WHERE department_id IN(10,30) AND salary > 3500

--Exercitiul 15
SELECT SYSDATE
FROM dual

--Exercitiul 16
SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = 1987

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE('%87%')


--Exercitiul 17
SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL

--Exercitiul 18 --TEMA
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct > 0
ORDER BY salary, commission_pct ASC

--Exercitiul 19
SELECT last_name, salary, commission_pct
FROM employees
ORDER BY salary DESC, commission_pct DESC

--Exercitiul 20 -TEMA
SELECT last_name
FROM employees
WHERE UPPER(last_name) LIKE('__A%');

--Exercitiul 21
SELECT last_name, department_id, manager_id
FROM employees
WHERE UPPER(last_name) LIKE('%L%L%');


--Exercitiul 22 - TEMA
SELECT last_name, job_id, salary
FROM employees
WHERE (UPPER(job_id) LIKE('%CLERK%') OR UPPER(job_id) LIKE('%REP%')) AND (salary <> 1000 AND salary <> 2000 AND salary <> 3000);
DESC employees
--Exerctiul 23
SELECT last_name, salary, commission_pct
FROM employees
WHERE salary > 5 * salary * commission_pct;



