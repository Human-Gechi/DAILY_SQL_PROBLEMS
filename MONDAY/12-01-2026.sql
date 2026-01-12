/*Find the number of workers by department who joined on or after April 1, 2014.
Output the department name along with the corresponding number of workers.
Sort the results based on the number of workers in descending order.
COMPANY: AMAZON
*/
SELECT
    COUNT(WORKER_ID),
    DEPARTMENT
FROM WORKER
WHERE JOINING_DATE >= CAST('2014-04-01' AS DATE)
GROUP BY DEPARTMENT

/*Find the details of each customer regardless of whether the customer made an order. Output the customer's first name, last name, and the city along with the order details.
Sort records based on the customer's first name and the order details in ascending order.*/

SELECT
    C.FIRST_NAME,
    C.LAST_NAME,
    C.CITY,
    O.ORDER_DETAILS
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O ON O.CUST_ID = C.ID
ORDER BY C.FIRST_NAME, O.ORDER_DETAILS;

/*Find order details made by Jill and Eva.
Consider the Jill and Eva as first names of customers.
Output the order date, details and cost along with the first name.
Order records based on the customer id in ascending order.
COMPANY : SHOPIFY
*/

SELECT
    C.FIRST_NAME,
    O.ORDER_DATE,
    O.ORDER_DETAILS,
    O.TOTAL_ORDER_COST
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O ON C.ID = O.CUST_ID
WHERE C.FIRST_NAME IN ('Jill', 'Eva')
GROUP BY C.FIRST_NAME, O.ORDER_DATE, C.ID, O.ORDER_DETAILS, O.TOTAL_ORDER_COST
ORDER BY C.ID ASC

-- Compare each employee's salary with the average salary of the corresponding department.
-- Output the department, first name, and salary of employees along with the average salary of that department
--COMPANY : SALESFORCE, GLASSDOOR

SELECT
    DEPARTMENT,
    FIRST_NAME,
    SALARY,
    AVG(salary) OVER (PARTITION BY DEPARTMENT) as dept_avg_salary
FROM EMPLOYEE
GROUP BY DEPARTMENT,FIRST_NAME, SALARY

/*Find songs that have ranked in the top position. Output the track name and the number of times it ranked at the top.
Sort your records by the number of times the song was in the top position in descending order.
COMPANY : SPOTIFY */

SELECT
    COUNT(*),
    TRACKNAME
FROM spotify_worldwide_daily_song_ranking
WHERE POSITION = 1
GROUP BY TRACKNAME, POSITION
ORDER BY COUNT(*) DESC;

/*Find how many times each artist appeared on the Spotify ranking list.
Output the artist name along with the corresponding number of occurrences.
Order records by the number of occurrences in descending order.
COMPANY: SPOTIFY
*/

SELECT
    COUNT(*),
    ARTIST
FROM spotify_worldwide_daily_song_ranking
GROUP BY ARTIST
ORDER BY COUNT(*) DESC;

/*Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD.
Output all details related to retrieved records.
COMPANY : LYFT */
SELECT
    *
FROM LYFT_DRIVERS
WHERE (YEARLY_SALARY <= 30000) OR (YEARLY_SALARY >= 70000);

/* Meta/Facebook has developed a new programing language called Hack.
To measure the popularity of Hack they ran a survey with their employees.
The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack by office location. Luckily the user IDs of employees completing the surveys were stored.
Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.
COMPANY : FACEBOOK
*/

SELECT
    AVG(FHK.POPULARITY),
    FE.LOCATION
FROM FACEBOOK_EMPLOYEES AS FE
INNER JOIN FACEBOOK_HACK_SURVEY AS FHK ON FE.ID = FHK.EMPLOYEE_ID
GROUP BY FE.LOCATION

/*Calculate the percentage of users who are both from the US and have an 'open' status, as indicated in the fb_active_users table.*/
SELECT
    (SUM
    (CASE WHEN status = 'open' AND COUNTRY = 'USA' THEN 1 END) * 100.0 / COUNT(*)
    ) AS open_user_percentage
FROM FB_ACTIVE_USERS;