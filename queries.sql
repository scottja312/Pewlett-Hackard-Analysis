
-- Count the number of employees retiring and produce table.
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Skill Drill: Queries for employees born in 1953, 1954, 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--- Joining departments and dept_manager tables (old code).
--SELECT departments.dept_name,
     --dept_manager.emp_no,
     --dept_manager.from_date,
     --dept_manager.to_date
--FROM departments
--INNER JOIN dept_manager
--ON departments.dept_no = dept_manager.dept_no;

--- Joining departments and dept_manager tables (using aliases).
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- 1: Remake new table by dropping retirement_info table.
DROP TABLE retirement_info;

-- 2: Create new table for retiring employees.
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- 2. Check the new retirement table.
SELECT * FROM retirement_info

-- 3: Joining retirement_info and dept_emp tables.
SELECT retirement_info.emp_no,
     retirement_info.first_name,
     retirement_info.last_name,
     dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--4: Use left join for retirement_info and dept_emp tables.
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