/* Identify returning active users by finding users who made a repeat purchase within 7 days or less of their previous transaction,
excluding same-day purchases. Output a list of these user_id.

Table
amazon_transactions

*/

SELECT
    user_id
FROM
(SELECT
    user_id,
    created_at,
    created_at - LAG(created_at) OVER(PARTITION BY user_id ORDER BY created_at) as previous_transactions
FROM amazon_transactions)
WHERE previous_transactions between 1 and 7
GROUP BY user_id;

/*
Workers With The Highest Salaries

Management wants to analyze only employees with official job titles.
Find the job titles of the employees with the highest salary. If multiple employees have the same highest salary, include all their job titles.

Tables

worker
title
*/

WITH highest AS (
    SELECT
    w.worker_id as worker_id,
    w.salary as salary,
    t.worker_title as title
    FROM worker as w
    INNER JOIN title as t
    ON t.worker_ref_id = w.worker_id
)

SELECT
    title
FROM highest
WHERE SALARY IN (SELECT MAX(SALARY) FROM highest);

/*
Given users' session logs, calculate how many hours each user was active in total across all recorded sessions.


Note: The session starts when state=1 and ends when state=0.

Table
cust_tracking
*/
WITH session_track AS (
    SELECT
        cust_id,
        state,
        -- 3600 seconds make an hour. E.g Epoch calculates timestamp in seconds
        -- Lead by current timestamp and check till the final timestamp for each user
        EXTRACT(EPOCH FROM (LEAD(timestamp) OVER (PARTITION BY cust_id ORDER BY timestamp) - timestamp)) / 3600 AS session_hours
    FROM cust_tracking
)
SELECT
    cust_id,
    SUM(session_hours) AS total_active_hours --- add up all the hours
FROM session_track
WHERE state = 1
GROUP BY cust_id;

/*Find the last time each bike was in use.
Output both the bike number and the date-timestamp of the bike's last use (i.e., the date-time the bike was returned).
Order the results by bikes that were most recently used.

Table
dc_bikeshare_q1_2012
*/

SELECT
    bike_number,
    max(end_time) as last_used
FROM dc_bikeshare_q1_2012
GROUP BY bike_number
ORDER BY last_used DESC