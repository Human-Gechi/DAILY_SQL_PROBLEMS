/*You are given a table named airbnb_host_searches that contains listings shown to users during Airbnb property searches.
Each record represents a property listing (not the user's search query).
Determine the minimum, average, and maximum rental prices for each host popularity rating based on the property's number_of_reviews.*/

WITH RATING AS
(SELECT
    PRICE,
    CASE WHEN number_of_reviews = 0 THEN 'New'
        WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
        WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
        WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
        WHEN number_of_reviews > 40 THEN 'Hot'
    END AS host_popularity
FROM AIRBNB_HOST_SEARCHES)

SELECT
    host_popularity,
    MIN(PRICE),
    MAX(PRICE),
    AVG(PRICE)
FROM RATING
GROUP BY HOST_POPULARITY
ORDER BY MIN(PRICE)

