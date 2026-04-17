/*
Write a query to print all prime numbers less than or equal to .
Print your result on a single line, and use the ampersand () character as your separator (instead of a space).
For example, the output for all prime numbers  would be:
2&3&5&7
*/
-- MySQL flavour [GROUP_CONCAT]
-- A postgressql ALT == STRING_AGG
WITH RECURSIVE numbers AS (
    SELECT 2 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n + 1 <= 999
),
prime AS (
SELECT n
FROM numbers n1
WHERE NOT EXISTS (
    SELECT 1
    FROM numbers n2
    WHERE n2.n > 1 AND n2.n < n1.n AND n1.n % n2.n = 0
)
)
SELECT GROUP_CONCAT(n SEPARATOR '&') FROM prime