/*Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit.
Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit.
Only consider sessions where the page_load occurs before the page_exit on the same day. Output the user_id and their average session time.*/
WITH page_load as (
    SELECT
        user_id,
        DATE(timestamp) as load_date,
        MAX(timestamp) as max_timestamp
    FROM facebook_web_log
    WHERE action = 'page_load'
    GROUP BY 1,2
),
page_exit as(
    SELECT
        user_id,
        DATE(timestamp) as exit_date,
        MIN(timestamp) as min_timestamp
    FROM facebook_web_log
    WHERE action ='page_exit'
    GROUP BY 1, 2
),
date_diff as(
    SELECT
        l.user_id as user_id,
        EXTRACT(EPOCH FROM (e.min_timestamp - l.max_timestamp)) as epoch_time
    FROM page_load as l
    INNER JOIN page_exit as e
    ON l.user_id = e.user_id AND l.load_date = e.exit_date
    GROUP BY l.user_id,l.max_timestamp,e.min_timestamp
)

SELECT
    user_id,
    AVG(epoch_time)
FROM date_diff
GROUP BY user_id

/*Identify the most engaged guests by ranking them according to their overall messaging activity.
The most active guest, meaning the one who has exchanged the most messages with hosts, should have the highest rank.
If two or more guests have the same number of messages, they should have the same rank. Importantly, the ranking shouldn't skip any numbers, even if many guests share the same rank.
Present your results in a clear format, showing the rank, guest identifier, and total number of messages for each guest, ordered from the most to least active.*/
SELECT
    id_guest,
    SUM(n_messages) as sum_n_messages,
    DENSE_RANK() OVER(ORDER BY SUM(n_messages) DESC) as guest_rank
FROM airbnb_contacts
GROUP BY id_guest

/*Find the number of inspections that resulted in each risk category per each inspection type.
Consider the records with no risk category value belongs to a separate category.
Output the result along with the corresponding inspection type and the corresponding total number of inspections per that type.
The output should be pivoted, meaning that each risk category + total number should be a separate column.
Order the result based on the number of inspections per inspection type in descending order.*/
SELECT
    inspection_type,
    SUM(CASE
        WHEN risk_category IS NULL THEN 1 ELSE 0
        END) AS no_risk_results,
    SUM(CASE
        WHEN risk_category = 'High Risk' THEN 1 ELSE 0
       END ) AS high_risk_results,
    SUM(CASE
        WHEN risk_category = 'Low Risk' THEN 1 ELSE 0
        END) AS low_risk_results,
    SUM(CASE
        WHEN risk_category = 'Moderate Risk' THEN 1 ELSE 0
       END ) AS medium_rik_results,
    COUNT(*) as total_inspections
FROM sf_restaurant_health_violations
GROUP BY inspection_type
ORDER BY 6 DESC

/*The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.

stock_prices Schema:
Column Name	Type	Description
date	datetime	The specified date (mm/dd/yyyy) of the stock data.
ticker	varchar	The stock ticker symbol (e.g., AAPL) for the corresponding company.
open	decimal	The opening price of the stock at the start of the trading day.
high	decimal	The highest price reached by the stock during the trading day.
low	decimal	The lowest price reached by the stock during the trading day.
close	decimal	The closing price of the stock at the end of the trading day.
*/
WITH highest_prices AS(
SELECT
  ticker,
  TO_CHAR(date, 'Mon-YYYY') AS highest_mth,
  MAX(open) AS highest_open,
  ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open DESC) AS row_num
FROM stock_prices
GROUP BY ticker,TO_CHAR(date, 'Mon-YYYY'), open
),

lowest_prices AS(
SELECT
  ticker,
  TO_CHAR(date, 'Mon-YYYY') AS lowest_mth,
  MIN(open) AS lowest_open,
  ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open ASC) AS row_num
FROM stock_prices
GROUP BY ticker,TO_CHAR(date, 'Mon-YYYY'), open
)

SELECT
  high.ticker,
  high.highest_mth,
  high.highest_open,
  low.lowest_mth,
  low.lowest_open
FROM highest_prices as high
INNER JOIN lowest_prices as low
ON high.ticker = low.ticker
AND high.row_num = 1
AND low.row_num = 1
ORDER BY high.ticker



