-- Challenge Assignment:
-- Deliverable 1: Number of Retiring Employees by Title
SELECT ce.emp_no,
       ce.first_name,
	   ce.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO ret_titles
FROM current_emp as ce
	INNER JOIN titles as ti
		ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no;

SELECT * FROM ret_titles