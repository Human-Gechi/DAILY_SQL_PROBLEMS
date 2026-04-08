-- Find departments with at more than or equal 5 employees.
SELECT
    department
FROM employee
GROUP BY department
HAVING COUNT(distinct id) >= 5

--- Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.
-- Distinct was used becaused initially post id was repeated twice
SELECT
    distinct
    fp.*
FROM facebook_posts as fp
INNER JOIN facebook_reactions as fr
ON fr.post_id = fp.post_id
WHERE fr.reaction = 'heart'

/*The product team is launching a new WhatsApp notification feature and needs to identify users who haven't provided their phone numbers yet.
These users will be shown a prompt to add their contact information.

Find all users who have not provided a phone number. Return the user ID and name.*/
SELECT
    user_id,
    user_name
FROM fintech_app_users
WHERE phone_number IS NULL

/*Find all employees who earn more than $80,000 and work in either the HR or Admin department.
Return first name, last name, department, and salary.*/
SELECT
    first_name,
    last_name,
    department,
    salary
FROM techcorp_workforce
WHERE department IN ('HR','Admin') AND salary > 80000;

/*The data quality team is auditing employee records to assess the completeness of contact information.
Calculate and return the ratio of employees who have a NULL phone number.*/
SELECT
    ((COUNT(*) - COUNT(phone_number)) * 1.0 / COUNT(*))::DECIMAL(10,2) AS missing_phone_ratio
FROM techcorp_workforce;
/*Find all inspection details made for facilities owned by 'GLASSELL COFFEE SHOP LLC'.*/
SELECT
    *
FROM los_angeles_restaurant_health_inspections
WHERE owner_name = 'GLASSELL COFFEE SHOP LLC'
/*Count the total number of violations that occurred at 'Roxanne Cafe' for each year, based on the inspection date.
Output the year and the corresponding number of violations in ascending order of the year.*/
SELECT
    COUNT(violation_id) as no_of_violattions
    EXTRACT(YEAR FROM inspection_date) as inspection_year
FROM sf_restaurant_health_violations
WHERE business_name = 'Roxanne Cafe'
GROUP BY EXTRACT(YEAR FROM inspection_date);

/*Find drafts which contains the word 'optimism'.*/
SELECT
*
FROM google_file_store
WHERE contents ILIKE '%optimism%' and filename ILIKE 'draft%';

/*Find all workers whose first name contains 6 letters and also ends with the letter 'h'.*/
SELECT
    *
FROM worker
WHERE length(first_name) = 6 AND first_name ILIKE '%h';
/*Find all athletes who were older than 40 years when they won either Bronze or Silver medals.*/
SELECT
name
FROM olympics_athletes_events
WHERE age > 40 and medal IN ('Bronze', 'Silver')

/*What is the total sales revenue of Samantha and Lisa?*/
SELECT
    SUM(sales_revenue)
FROM sales_performance
WHERE salesperson IN ('Samantha', 'Lisa')

/*Find all the users who were active for 3 consecutive days or more.*/
WITH distinct_record_dates AS (
    SELECT DISTINCT
        user_id,
        record_date AS distinct_dates
    FROM sf_events
),
grouped_dates AS (
    SELECT
        user_id,
        distinct_dates,
        distinct_dates - ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY distinct_dates
        )::int AS consecutive_days
    FROM distinct_record_dates
)
SELECT
    user_id
FROM grouped_dates
GROUP BY user_id, consecutive_days
HAVING COUNT(*) >= 3;

/*We have a table with employees and their salaries; however, some of the records are old and contain outdated salary information. Since there is no timestamp, assume salary is non-decreasing over time. You can consider the current salary for an employee is the largest salary value among their records. If multiple records share the same maximum salary, return any one of them. Output their id, first name, last name, department ID, and current salary.
Order your list by employee ID in ascending order.*/
WITH emp_record_change AS (SELECT
    id,
    first_name,
    last_name,
    department_id,
    salary,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY salary DESC, department_id DESC) as rnk
FROM ms_employee_salary
GROUP BY 1,2,3,4,5
ORDER BY id ASC)

SELECT
    id,
    first_name,
    last_name,
    department_id,
    salary
FROM emp_record_change
WHERE rnk = 1

