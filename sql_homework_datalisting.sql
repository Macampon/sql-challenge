-- import csv files  titles, employee,salaries,departments,dept_manager&dept_emp
show datestyle;
--to be able to import employee csv, update hire_date&birth_date column type to varchar since datestyle of postgres is ISO,DMY and not ISO,MDY
alter table employees
alter column birth_date type varchar;
alter table employees
alter column hire_date type varchar;

-- query the data
select * from titles;
select count(emp_no) from employees;
select * from employees;
select count(emp_no) from salaries;
select count(dept_no) from departments;
select * from departments;
select count(dept_no) from dept_managers;
select count(dept_no) from dept_emp;

-- after uploading of the data, change the birth_date and hire_date back to type date
-- changing datestyle is per session and it will not affect the database setup. Once you open a new session datestyle is ISO, DMY
-- based on the data, the datestyle is MDY

set datestyle = 'ISO, MDY';  

alter table employees
alter column birth_date type date USING birth_date::date;
alter table employees
alter column hire_date type date USING hire_date::date;

-- DATA ANALYSIS
-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.

select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees e,
     salaries s
where e.emp_no = s.emp_no

-- another way

select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees e
inner join salaries s on e.emp_no = s.emp_no

--2.List first name, last name, and hire date for employees who were hired in 1986.

select first_name, last_name, hire_date 
from employees_test
where to_char(hire_date,'YYYY') = '1986';

--3.List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.

select dm.dept_no department_number, d.dept_name department_name, e.emp_no employee_number, e.last_name surname, e.first_name first_name
from dept_managers dm
Join departments d 
on dm.dept_no = d.dept_no
Join employees e	 
on dm.emp_no = e.emp_no

--- another solution
select dm.dept_no department_number, d.dept_name department_name, e.emp_no employee_number, e.last_name surname, e.first_name first_name
from dept_managers dm,
     departments d,
	 employees e	 
where 
dm.dept_no = d.dept_no
and dm.emp_no = e.emp_no


--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

select e.emp_no employee_number, e.last_name surname, e.first_name first_name, d.dept_name department_name
from employees e
Join dept_emp de
on   e.emp_no = de.emp_no
Join departments d
on   de.dept_no = d.dept_no
 
-- or 
 select e.emp_no employee_number, e.last_name surname, e.first_name first_name, d.dept_name department_name
from employees e,
     dept_emp de,
     departments d
 where e.emp_no = de.emp_no
 and de.dept_no = d.dept_no

--5. List first name, last name, and sex for employees whose first name is "Hercules" and 
--last names begin with "B."

select first_name, last_name , sex
from employees
where 
first_name = 'Hercules'
and last_name like 'B%';


--6. List all employees in the Sales department, 
--including their employee number, last name, first name, and department name.

select e.emp_no employee_number, e.last_name surname, e.first_name first_name, d.dept_name department_name
from employees e,
     dept_emp de,
     departments d
 where e.emp_no = de.emp_no
 and de.dept_no = d.dept_no
 and d.dept_name = 'Sales'
 

--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
select e.emp_no employee_number, e.last_name surname, e.first_name first_name, d.dept_name department_name
from employees e,
     dept_emp de,
     departments d
 where e.emp_no = de.emp_no
 and de.dept_no = d.dept_no
 and d.dept_name in ('Sales','Development')
 
--8. In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.

select last_name, count(last_name) count_surname
from employees
group by last_name
order by count_surname desc;







