/*Question
You have a dataset that records daily active users for each premium account. A premium account appears in the data every day as long as it remains premium. However, some premium accounts may be temporarily discounted, meaning they are not actively paying — this is indicated by a final_price of 0.
For each date, count the number of premium accounts that were actively paying on that day. Then, track how many of those same accounts are still premium and actively paying exactly 7 days later, if that later date exists in the dataset. Return results for the first 7 dates in the dataset.
Output three columns:
The date of initial calculation.
The number of premium accounts that were actively paying on that day.
The number of those accounts that remain premium and are still paying after 7 days.*/

WITH USERS AS(
    SELECT account_id, ENTRY_DATE FROM PREMIUM_ACCOUNTS_BY_DAY
    WHERE FINAL_PRICE > 0
GROUP BY ENTRY_DATE, ACCOUNT_ID)

SELECT
    U.ENTRY_DATE,
    COUNT(DISTINCT U.ACCOUNT_ID) AS PREMIUM_ACCOUNTS,
    COUNT(DISTINCT U_7.ACCOUNT_ID) AS PREMIUN_ACCOUNTS_7DAYS
FROM USERS AS U
LEFT JOIN USERS AS U_7
ON U.ACCOUNT_ID =  U_7.ACCOUNT_ID
AND (U_7.ENTRY_DATE - U.ENTRY_DATE) = 7
GROUP BY U.ENTRY_DATE
ORDER BY U.ENTRY_DATE ASC
LIMIT 7;

/*Find the top 10 ranked songs in 2010.
Output the rank, group name, and song name, but do not show the same song twice. Sort the result based on the rank in ascending order.*/

SELECT
    GROUP_NAME,
    SONG_NAME,
    year_rank
FROM BILLBOARD_TOP_100_YEAR_END
WHERE YEAR = 2010 AND YEAR_RANK BETWEEN 1 AND 10
GROUP BY GROUP_NAME, SONG_NAME, YEAR_RANK
ORDER BY YEAR_RANK ASC

/*Identify the IDs of students who scored exactly at the median for the SAT writing section.*/
SELECT
    STUDENT_ID
FROM SAT_SCORES
WHERE SAT_WRITING = (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY SAT_WRITING) AS median_score FROM SAT_SCORES);