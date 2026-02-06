/*Write a query to print all prime numbers less than or equal to .
Print your result on a single line, and use the ampersand () character as your separator (instead of a space)
For example, the output for all prime numbers  < 10 would be: 2&3&5&7*/

WITH RECURSIVE Numbers AS (
    SELECT 2 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000
),
NotPrimes AS (
    SELECT DISTINCT n1.n
    FROM Numbers n1
    JOIN Numbers n2 ON n2.n < n1.n
    WHERE n1.n % n2.n = 0
)

SELECT GROUP_CONCAT(n SEPARATOR '&')
FROM Numbers
WHERE n NOT IN (SELECT n FROM NotPrimes);

/*
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date.
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the tabl
If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order.
If there is more than one project that have the same number of completion days, then order by the start date of the project.
*/

WITH START AS
    (SELECT
        START_DATE
    FROM PROJECTS
    WHERE START_DATE NOT IN (SELECT END_DATE from PROJECTS)
    ),

ENDING AS (
    SELECT
        END_DATE
    FROM PROJECTS
    WHERE
        END_DATE NOT IN (SELECT START_DATE from PROJECTS)
    )

SELECT S.START_DATE,
    MIN(E.END_DATE) FROM START AS S, ENDING AS E
    WHERE S.START_DATE < E.END_DATE
    GROUP BY S.START_DATE
    ORDER BY DATEDIFF(MIN(E.END_DATE),S.START_DATE) ASC, S.START_DATE