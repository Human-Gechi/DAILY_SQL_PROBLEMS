/*Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.*/
WITH tweet_counts AS (
    SELECT
        user_id,
        COUNT(tweet_id) AS tweet_bucket
    FROM tweets
    WHERE EXTRACT(YEAR FROM tweet_date) = 2022
    GROUP BY user_id
)

SELECT
    tweet_bucket,
    COUNT(user_id) AS users_num
FROM tweet_counts
GROUP BY tweet_bucket
ORDER BY tweet_bucket;

/*Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

*/
SELECT
  DISTINCT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING(COUNT(DISTINCT skill)) = 3
