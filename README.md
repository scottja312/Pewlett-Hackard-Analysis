# Pewlett-Hackard-Analysis
# SBAR (Situation, Background, Assessment, Resolution).
# S - Situation (paragraph 1)
In the Pewlett-Hackard company, my role as a data analyst was to assist Bobby in  


# Assessment:
In order to 
--A. Beginning of queries to determine retirement eligibility---
--A 1. Get names of employees born within 1952.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--A. 1a. Narrow search for retirement elibility
-----by names of employees based on 
-----specific hiring date range and birth date range.
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Skill Drill 1: Create addtional queries for employees born in 1953, 1954, 1955.
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

--A. 3: Create new table for retiring employees.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--A. 4: Check the new retirement table.
SELECT * FROM retirement_info

--B. Create a new table for retiring employees that includes the emp_no.
--B. 1: Recreate new table by dropping retirement_info table.
DROP TABLE retirement_info;

-- B. 2: Create new retirement_info table.
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--B. 2a: Check the new retirement_info table with now-added employee numbers.
SELECT * FROM retirement_info;

--Practice joining tables: inner join departments and dept_manager tables. 
--Note: this is the query code w/o aliases.
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
--B. Note: The new table created from this query has a 
-----from_date and to_date.
-----Notice that the retirement_info table has employees selected 
-----based on hire date and birth date, but how many employees have 
-----already left that might be still included in this list?
-----We need to create a new joined table using the
-----retirement_info table.

--B. Fully accurate retirement_info table needs:
-----Employee number
-----Employee name (first and last)
-----If the person is presently employed with PH.
--B. 3: Join new retirement_info table and dept_emp table (using left join).
SELECT retirement_info.emp_no,
     retirement_info.first_name,
     retirement_info.last_name,
     dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
--B. Note: new joined table shows date in which all eligible employee are included, 
-----including those who left before retirement eligibility; 
-----'9999' indicates person still works for the company.

-----------------------
--Queries Using Aliases
-----------------------
--NOTE: an alias in SQL allows developers to give nicknames
--to tables. Helps improve code readibility by shortening
--longer names into one-, two-, or three-letter temporary
--names.
--C. 1. Re-write using aliases left join on departments and dept_manager tables.
--Note: For this join, d(departments), dm (dept_manager).
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--C. 2. Use left join for retirement_info (ri) and dept_emp (de) tables
------to re-write original query in aliases, and then make 
------new table of current retirement employees (current_emp).
--Basic info needed: employee number, first name, last name, to-date.
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
--Note: 9999 indicates they are still employed. 

--C. 3. Check the new retirement eligibility table, current_emp.
SELECT * FROM current_emp

--------------------------------------
--Use Count, Group By, and Order By--
--------------------------------------
--D. NOTE: "COUNT" and "GROUP BY" with joins are used
--to separate the employees into their departments
--(similar to use in Pandas).
----"COUNT" will count the rows of data in a dataset.
----"GROUP BY" groups our data by type.
----"ORDER BY" will arrange the data by descending or ascending
-----order.
--D. 1. Retiring employee count by department number. 
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
--NOTE: When code is run to line "GROUP BY",
--data output is not in order.
--Run code on "ORDER BY" and the data of how many retirees will be organized by department number.
ORDER BY de.dept_no;
--Note: left join on current_emp (new retirement eligibility table) 
--and dept_emp tables, "COUNT" will count the employee numbers,
--"GROUP BY" gives us the number of employees retiring 
--from each department.

--D. 2. Skill drill: Update the code block to put the new employee counts by department
------into a table, and then export as a csv.
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--D. 3. Check the new table of retiree numbers by department, emp_count.
SELECT * FROM emp_count

-------------------------------------
--Create Additional Lists--
-------------------------------------
--Note: Since there are anywhere between 2,000-9,000 (roughly) employees 
--retiring from each department, the boss wants three lists
--that are more specific:
--------- 1. Employee information: A list of employees containing:
-------------employee number, first/last name, gender, salary.
--E. 1. Run a query to check salaries table, in order of descending date.
SELECT * FROM salaries
ORDER BY to_date DESC;
--Note: this query returned dates that do not show the most
--recent date of employment, so first check employees table.
--Need: employee number, first name, last name, gender, to_date, salary.

--E. 2. Create new placeholder table emp_info, 
--------with updated retiree filtered list from employees 
--------table (recall previous code).
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--E. 3. Join new emp_info table to the salaries table, to add the
------"to_date" and "salaries" column to the query.
--Note: using aliases, s is for salary table,
--e is for employees table, and de is dept_emp table.
SELECT e.emp_no, 
	   e.first_name, 
	   e.last_name, 
	   e.gender,
	   s.salary,
	   de.to_date
INTO emp_info
FROM employees as e
--[Note]: First join- employees and salaries (inner join).
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
--[Note]: Second join- dept_emp to employees. (inner join with filter).
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01');

--E. 2. Check the new table.
SELECT * FROM emp_info
--Note (Observation 1): for eligible retirees, the salaries don't show any employee raises over the years.

----
---List 2: Management: A list of managers for each department, 
---including the department number, name, and 
---the manager’s employee number, last name, first name, 
---and the starting and ending employment dates.
--Note: ce is current_emp table. 
-- E. 1. Create managers per department list and export as csv.
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
--E. 2. Check the new table.
SELECT * FROM manager_info
--Note: (Observation 2: Only five departments have active managers.)

-----
---List 3. Department Retirees: An updated current_emp table with
------the employee’s departments.
-- E. 1. Create department retirees list and export as csv.
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
		
--E. 2. Check the new table.
SELECT * FROM dept_info
--Note: (Observation 3: Why are some employees appearing twice?)

-------------------
--Tailored Lists
-------------------
--Skill Drill 1: Create list of Sales team employees.
--Note: This list will contain everything in the retirement_info table,
--------only tailored for the Sales team. 
---Include: employee numbers, first/last name, employee department name.
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

--E. 2. Check the new table.
SELECT * FROM emp_sales

--Skill Drill 2: Create list of Sales and Development team employees.
---Include: employee numbers, first/last name, employee department name.
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

--E. 2. Check the new table.
SELECT * FROM emp_sales_dev
