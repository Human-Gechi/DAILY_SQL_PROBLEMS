/*
You are given a set of projects and employee data. Each project has a name, a budget, and a specific duration, while each employee has an annual salary and may be assigned to one or more projects for particular periods.
The task is to identify which projects are overbudget.
A project is considered overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.
To solve this, you must prorate each employee's annual salary based on the exact period they work on a given project, relative to a full year.
For example, if an employee works on a six-month project, only half of their annual salary should be attributed to that project. Sum these prorated salary amounts for all employees assigned to a project and compare the total with the project’s budget.
Your output should be a list of overbudget projects, where each entry includes the project’s name, its budget, and the total prorated employee expenses for that project.
The total expenses should be rounded up to the nearest dollar. Assume all years have 365 days and disregard leap years.

Tables
linkedin_projects
linkedin_emp_projects
linkedin_employees
*/

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


/*
You are given an exam_results table containing student exam scores.

Column Name	Type
student_id	int
exam_id	int
score	int
(student_id, exam_id) is the primary key (combination of columns with unique values) for this table.
Each row represents a student's score on a particular exam. The score column is never NULL.

Write a query to find each student's highest score along with the corresponding exam_id.
If a student has the same highest score on multiple exams, return the one with the smallest exam_id.

Return the student_id, exam_id, and score, ordered by student_id in ascending order.

Example 1:

Input:

exam_results table:

student_id	exam_id	score
1	101	85
1	102	92
2	101	88
2	102	88
3	101	70
3	102	65
3	103	78
Output:

student_id	exam_id	score
1	102	92
2	101	88
3	103	78
*/

SELECT
    student_id,
    exam_id,
    score
FROM (
    SELECT
        student_id,
        exam_id,
        score,
        ROW_NUMBER() OVER(PARTITION BY student_id ORDER BY score DESC, exam_id ASC) as position
    FROM exam_results
) as ranked_exams
WHERE position = 1