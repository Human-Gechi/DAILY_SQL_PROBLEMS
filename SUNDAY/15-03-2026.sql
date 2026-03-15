SELECT
    title,
    budget,
    CEIL(SUM(perforated_salary))
FROM (
SELECT
    p.title,
    p.budget,
    (emp.salary::float/ 365) * (p.end_date - p.start_date) as perforated_salary
FROM linkedin_projects as p
INNER JOIN linkedin_emp_projects as pro
ON p.id = pro.project_id
INNER JOIN linkedin_employees AS emp
ON emp.id = pro.emp_id
) AS project_employees
GROUP BY title,budget
HAVING (SUM(perforated_salary)) > budget

