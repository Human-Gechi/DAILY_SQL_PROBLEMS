/*Write a query that will calculate the number of shipments per month.
The unique key for one shipment is a combination of shipment_id and sub_id.
Output the year_month in format YYYY-MM and the number of shipments in that month.*/

SELECT
    COUNT(CONCAT(SHIPMENT_ID, SUB_ID)) as shipment_count,
    CONCAT(EXTRACT(YEAR FROM SHIPMENT_DATE), '-', EXTRACT(MONTH FROM SHIPMENT_DATE)) AS YEAR_MONTH
FROM AMAZON_SHIPMENT
GROUP BY YEAR_MONTH;

