/*Calculate the total revenue from each customer in March 2019. Include only customers who were active in March 2019. An active user is a customer who made at least one transaction in March 2019.
Output the revenue along with the customer id and sort the results based on the revenue in descending order.*/

SELECT
    SUM(TOTAL_ORDER_COST),
    CUST_ID
FROM ORDERS
WHERE EXTRACT('Month' from order_date) = 03 AND EXTRACT('Year' FROM order_date) = 2019
GROUP BY CUST_ID
HAVING COUNT(order_details) >= 1
ORDER BY SUM(TOTAL_ORDER_COST) DESC;

/*Make a report showing the number of survivors and non-survivors by passenger class. Classes are categorized based on the pclass value as:

First class: pclass = 1
Second class: pclass = 2
Third class: pclass = 3

Output the number of survivors and non-survivors by each class*/

SELECT
    SURVIVED,
    SUM(CASE WHEN PCLASS = 3 THEN 1 ELSE 0 END) AS Third_class,
    SUM(CASE WHEN PCLASS = 2 THEN 1 ELSE 0 END) AS Second_class,
    SUM(CASE WHEN PCLASS = 1 THEN 1 ELSE 0 END) AS First_class
FROM TITANIC
GROUP BY SURVIVED;
/*Find the second highest salary of employees*/

WITH SECOND_CUST AS (SELECT
    SALARY,
    DENSE_RANK() OVER(ORDER BY SALARY DESC) AS RNK
FROM EMPLOYEE)
SELECT SALARY FROM SECOND_CUST
WHERE RNK = 2

/*Find the Olympics with the highest number of unique athletes.
The Olympics game is a combination of the year and the season, and is found in the games column.
Output the Olympics along with the corresponding number of athletes. The id column uniquely identifies an athlete.*/

SELECT
    GAMES,
    COUNT(DISTINCT(ID))
FROM olympics_athletes_events
GROUP BY GAMES
ORDER BY COUNT(DISTINCT(ID)) DESC
LIMIT 1;

/*Find employees who are earning more than their managers.
Output the employee's first name along with the corresponding salary.*/

WITH MANAGERS AS
  (SELECT id,
          salary
   FROM Employee)
SELECT E.first_name AS first_name,
       E.salary AS salary
FROM Employee AS E
JOIN MANAGERS AS M ON E.manager_id = M.id
WHERE E.salary > M.salary;