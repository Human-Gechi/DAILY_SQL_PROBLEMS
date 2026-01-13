/*Problem	Submissions	Leaderboard	Discussions
Query the average population for all cities in CITY, rounded down to the nearest integer.*/

SELECT
    ROUND(AVG(POPULATION),0) FROM CITY

/*Table description
You are given three tables: Students, Friends and Packages.
Students contains two columns: ID and Name.
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend).
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

QUESTION:
Write a query to output the names of those students whose best friends got offered a higher salary than them.
Names must be ordered by the salary amount offered to the best friends.
It is guaranteed that no two students got same salary offer.*/

SELECT
    s.NAME
from STUDENTS s
INNER JOIN FRIENDS f on s.id = f.id
INNER JOIN PACKAGES p on s.id = p.id
INNER JOIN PACKAGES p2 on f.friend_ID = p2.id
WHERE p2.salary > p.salary
ORDER BY P2.salary;

/*P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * *
* * * *
* * *
* *
*
Write a query to print the pattern P(20).*/

WITH RECURSIVE PATTERN AS (
    SELECT 20 AS n
    UNION ALL
    SELECT n - 1 FROM PATTERN WHERE n > 1
)
SELECT RPAD('*', n * 2 - 1, ' *')
FROM PATTERN;

/*P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

*
* *
* * *
* * * *
* * * * *
Write a query to print the pattern P(20).*/

WITH RECURSIVE PATTERN AS (
    SELECT 20 AS n
    UNION ALL
    SELECT n - 1 FROM PATTERN WHERE n > 1
)
SELECT RPAD('*', n * 2 - 1, ' *')
FROM PATTERN
ORDER BY n ASC;
