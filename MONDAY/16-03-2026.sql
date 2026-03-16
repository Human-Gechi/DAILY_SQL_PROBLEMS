/*
Given three tables containing information about sales representatives, companies, and orders, write a query to find salespeople who have never made sales to a specific company.

sales_person table:

Column Name	Type
sales_id	int
name	varchar
salary	int
commission_rate	int
hire_date	date
The sales_id column is the primary key. Each row contains information about a salesperson including their name, salary, commission rate, and when they were hired.

company table:

Column Name	Type
com_id	int
name	varchar
city	varchar
The com_id column is the primary key. Each row contains the company's ID, name, and the city where it is located.

orders table:

Column Name	Type
order_id	int
order_date	date
com_id	int
sales_id	int
amount	int
The order_id column is the primary key. The com_id column references the company table, and sales_id references the sales_person table. Each row represents an order with the company, salesperson, date, and amount.

Write a SQL query to find the names of all salespeople who have not made any orders with the company named "CRIMSON".

Return the result in any order.
*/

SELECT
    sp.name
FROM sales_person as sp
WHERE sp.sales_id NOT IN(
    SELECT
        o.sales_id
    FROM orders as o
    INNER JOIN company as c
    ON o.com_id = c.com_id
    WHERE c.name = 'CRIMSON'

)
GROUP BY sp.name
ORDER BY sp.name ASC

/*You are given two tables: variables which stores variable names and their integer values, and expressions which contains boolean expressions to evaluate.

variables table:

Column Name	Type
name	varchar
value	int
The name column is the primary key. Each row contains a variable name and its corresponding integer value.

expressions table:

Column Name	Type
left_operand	varchar
operator	enum
right_operand	varchar
The combination of (left_operand, operator, right_operand) forms the primary key.

The operator column can be one of: <, >, or =. Both left_operand and right_operand reference variable names from the variables table.

Write a query to evaluate each boolean expression and return the result as true or false.

The result can be returned in any order.
*/

SELECT
    e.left_operand,
    e.operator,
    e.right_operand,
    CASE
        WHEN e.operator = '<' AND lva.value < rva.value THEN true
        WHEN e.operator = '>' AND lva.value > rva.value THEN true
        WHEN e.operator = '=' AND lva.value = rva.value THEN true
        ELSE false
    END as value
FROM expressions as e
JOIN variables as lva ON lva.name = e.left_operand
JOIN variables as rva ON rva.name = e.right_operand

/*
Calculate the net change in the number of products launched by companies in 2020 compared to 2019.
Your output should include the company names and the net difference.
(Net difference = Number of products launched in 2020 - The number launched in 2019.)

Table
car_launches

*/
WITH products_2020 AS (
    SELECT
        company_name,
        COUNT( DISTINCT product_name) as product_count_2020
    FROM car_launches
    WHERE year = 2020
    GROUP BY company_name
),

products_2019 AS (
SELECT
    company_name,
    COUNT(DISTINCT product_name) AS product_count_2019
    FROM car_launches
    WHERE year = 2019
    GROUP BY company_name
)

SELECT
    p_2019.company_name,
    (P_2020.product_count_2020 - p_2019.product_count_2019) as net_products
FROM products_2019 AS p_2019
FULL OUTER JOIN products_2020 AS p_2020
ON p_2019.company_name = p_2020.company_name
GROUP BY p_2019.company_name, p_2020.product_count_2020, p_2019.product_count_2019



