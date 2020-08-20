---Beginning of queries to determine retirement eligibility---
--A 1. Get names of employees born within 1952.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--A. 1a. Get names of employees based on a specific hiring date range and birth date range.
-- Narrowing search for retirement eligibility.
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Skill Drill 1: Create addtional queries for employees born in 1953, 1954, 1955
--For 1953--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
--For 1954--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
--For 1955--
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--A. 2. Count the number of employees retiring and produce table.
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Remake new table by dropping retirement_info table.
DROP TABLE retirement_info;

--B. 1: Create new table for retiring employees.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--B. 2. Check the new retirement table.
SELECT * FROM retirement_info

--B. 3. Practice: join departments and dept_manager tables (old code using inner join).
--SELECT departments.dept_name,
     --dept_manager.emp_no,
     --dept_manager.from_date,
     --dept_manager.to_date
--FROM departments
--INNER JOIN dept_manager
--ON departments.dept_no = dept_manager.dept_no;

-- 4: Joining retirement_info and dept_emp tables (using left join).
SELECT retirement_info.emp_no,
     retirement_info.first_name,
     retirement_info.last_name,
     dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--Using Aliases--
--- 1. Joining departments and dept_manager tables (left join using aliases).
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
WHERE dm.to_date = ('9999-01-01');

-- 2. Use left join for retirement_info and dept_emp tables to make table of current retirement employees.
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--- 5. Check the new retirement table current_emp.
SELECT * FROM current_emp

-- 6. Employee count by department number (join current_emp and dept_emp tables)
SELECT COUNT(ce.emp_no), de.dept_no
--Skill drill: put employee count by department number table into a csv.
INTO emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--SELECT * FROM emp_count

-- 7. List 1: Create employee/salary information list with genders and export as csv.
SELECT * FROM salaries
ORDER BY to_date DESC;
--
SELECT e.emp_no, 
	   e.first_name, 
	   e.last_name, 
	   e.gender,
	   s.salary,
	   de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');
--SELECT * FROM emp_info

-- 8. List 2: Create managers per department list and export as csv.
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
---SELECT * FROM manager_info

-- 9. List 3: Create department retirees list and export as csv.
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);
--SELECT * FROM dept_info

--10. Skill Drill 1: Create list of Sales team employees.
SELECT ce.emp_no,
	   ce.first_name, 
	   ce.last_name, 
	   d.dept_name
INTO emp_sales
FROM current_emp as ce
	INNER JOIN dept_emp as de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales'
--SELECT * FROM emp_sales

--11. Skill Drill 2: Create list of Sales and Development team employees.
SELECT ce.emp_no,
	   ce.first_name, 
	   ce.last_name, 
	   d.dept_name
INTO emp_sales_dev
FROM current_emp as ce
	INNER JOIN dept_emp as de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales','Development')
ORDER BY ce.emp_no;