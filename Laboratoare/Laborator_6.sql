-- Laborator 6
-- metoda 1
select  distinct employee_id
from works_on a
where not exists 
        (select 1
         from project p
         where budget = 10000
         and not exists
         (select 'x'
          from works_on b
          where p.project_id = b.project_id
          and b.employee_id = a.employee_id
         )
        );
        
        
-- metoda 2
select employee_id
from works_on
where project_id in
    (select project_id
     from project
     where budget = 10000
    )
group by employee_id
having count(project_id) = (select count(*)
                            from project
                            where budget = 10000);
                            
        
   
-- Exercitiul 1
desc works_on;
select * from works_on;
select distinct employee_id
from works_on w
where not exists (select 1
                  from projects p
                  where ('01-JAN-2006' <= start_date) and (start_date < '01-JUL-2006')
                  and not exists
                  (select 1
                   from works_on w2
                   where w2.project_id = p.project_id
                   and w2.employee_id = w.employee_id
                  ));
                  
SELECT DISTINCT employee_id
FROM works_on w
WHERE NOT EXISTS ((SELECT project_id
                   FROM projects
                   WHERE EXTRACT(YEAR FROM start_date) = 2006
                   AND TO_CHAR(start_date, 'MM') <= 6)
                  MINUS
                  (SELECT project_id
                   FROM works_on w1
                   WHERE w1.employee_id = w.employee_id));   
                   
-- Exercitiul 2
-- acesti angajati au mai avut alte doua posturi in firma
with doua_posturi as (
    select employee_id
    from job_history
    group by employee_id
    having count(job_id) >= 2
)
select p.project_id
from project p
where not exists (
    select 1
    from works_on w1 join doua_posturi d on w1.employee_id = d.employee_id
    where not exists (
    select 1
    from works_on w2
    where (w2.employee_id = w1.employee_id and w2.project_id = p.project_id)
    ));
    
    
-- Exercitiul 3

with nr_joburi as (
    select employee_id, count(1) nr_job
    from job_history
    group by employee_id
    )
select e1.employee_id
from employees e1 join nr_joburi e2 on e1.employee_id = e2.employee_id
where nr_job >= 2;

-- Exercitiul 4
select country_id, count(employee_id) NrAngajati
from employees e join departments d on e.department_id = d.department_id
                join locations l on d.location_id = l.location_id
group by country_id;

-- Exercitiul 5
select * from project;
with deadline_depasit as 
    (
    select project_id
    from projects
    where delivery_date > deadline
)
select e.employee_id, last_name
from employees e
where 2 <= (select count(1)
            from works_on w join deadline_depasit d on d.project_id = w.project_id
            where w.employee_id = e.employee_id
);

-- Exercitiul 6
select e.employee_id, project_id
from employees e left join works_on w on e.employee_id = w.employee_id;

-- Exercitiul 7
select employee_id
from employees s
where exists (select 'x'
              from project p, employees e
              where p.project_manager = e.employee_id
              and e.department_id = s.department_id
);

-- Exercitiul 8
with project_managers as (
    select distinct project_manager as employee_id
    from project
    )
select first_name, last_name, department_id
from employees
where department_id not in (
    select distinct department_id
    from departments join employees using (department_id) join project_managers using(employee_id)
);

-- Exercitiul 9
select department_id
from employees
group by department_id
having avg(salary) > &p;

-- Exercitiul 10
select *
from projects;
with project_managers as (
        select project_manager as employee_id, count(1) AS nr_proiecte
        from project
        group by project_manager
)
select first_name, last_name, salary, nr_proiecte
from employees join project_managers using(employee_id)
where nr_proiecte >= 2;

-- Exercitiul 11
select distinct employee_id
from works_on w1
where not exists (
        select 1
        from project p
        where project_manager = 102 
        and not exists
        (
            select 1
            from works_on w2
            where w1.employee_id = w2.employee_id
            and 
                  p.project_id = w2.project_id
        )
);


-- Exercitiul 12
-- a
with angajati_200 as (
    select project_id
    from works_on
    where employee_id = 200
)
select distinct last_name, first_name
from employees e
where not exists (
    select 1
    from angajati_200
    where project_id in (select project_id
                         from works_on
                         where employee_id = e.employee_id)
);

-- b
with angajati_200 as (
    select project_id
    from works_on
    where employee_id = 200
)
select distinct last_name, first_name
from employees e
where not exists (
    select project_id
    from works_on
    where e.employee_id = employee_id
    and project_id not in (select * from angajati_200)
);

-- Exercitiul 13
with angajati_200 as (
    select project_id
    from works_on
    where employee_id = 200
)
select last_name
from employees e
where not exists (
    (select project_id
     from works_on
     where employee_id = e.employee_id)
     minus
     (select project_id
      from angajati_200
     )
)
and not exists(
    (select project_id
     from angajati_200 
    )
    minus
    (select project_id
     from works_on
     where employee_id = e.employee_id)

);

-- Exercitiul 14
-- a
desc job_grades;

-- b
select last_name, first_name, salary, grade_level
from employees join job_grades on (lowest_sal <= salary and salary <= highest_sal);

-- Exercitiul 16
select last_name, department_name, salary
from employees
where job_id = &job;

-- Exercitiul 17
select last_name, department_id, salary
from employees
where hire_date >= &data;

-- Exercitiul 18
select &&col
from &&tabel
where &&conditie
order by &col;

-- Exercitiul 19
accept start_date prompt "start_date= ";
accept end_date prompt "end date= ";
select last_name, job_id, hire_date
from employees
where hire_date between to_date('&start_date', 'MM/DD/YY')
    and to_date('&end_date', 'MM/DD/YY');
    
-- Exercitiul 20
select last_name, job_id, salary, department_name
from employees join departmentd using(department_id)
               join locations using(location_id)
where city like &location;

-- Exercitiul 21
-- a
accept start_date prompt "start date= ";
accept end_date prompt "end date= ";
select to_date('&end_date', 'MM/DD/YY') - to_date('&start_date', 'MM/DD/YY')
from dual;
-- b
select 5 * (to_date('&end_date', 'MM/DD/YY') - to_date('&start_date', 'MM/DD/YY')) / 7
from dual;
