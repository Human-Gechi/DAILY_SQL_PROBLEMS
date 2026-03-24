-- Calculates the difference between the highest salaries in the marketing and engineering departments. Output just the absolute difference in salaries.

SELECT
    ABS(
        MAX(CASE WHEN d.department = 'marketing' THEN emp.salary END) -
        MAX(CASE WHEN d.department = 'engineering' THEN emp.salary END)
    ) AS salary_difference
FROM db_employee AS emp
INNER JOIN db_dept AS d ON d.id = emp.department_id
WHERE d.department IN ('marketing', 'engineering');

/*
Find the best-selling item for each month (no need to separate months by year).
The best-selling item is determined by the highest total sales amount, calculated as: total_paid = unitprice * quantity.
A negative quantity indicates a return or cancellation (the invoice number begins with 'C'. To calculate sales, ignore returns and cancellations.
Output the month, description of the item, and the total amount paid.

Table
online_retail
*/

WITH best_selling AS(
SELECT
    EXTRACT(MONTH FROM invoicedate) as month,
    description,
    SUM(unitprice * Quantity) AS total_paid,
    RANK() OVER(PARTITION BY EXTRACT(MONTH FROM invoicedate) ORDER BY SUM(unitprice * Quantity) DESC) as rnk
FROM online_retail
WHERE quantity > 0
GROUP BY EXTRACT(MONTH FROM invoicedate),description)

SELECT
    month,
    description,
    total_paid
FROM best_selling
WHERE rnk = 1
GROUP BY description, month, total_paid
ORDER BY month ASC
