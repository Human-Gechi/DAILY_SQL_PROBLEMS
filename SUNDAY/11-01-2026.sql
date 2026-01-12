/*Write a query that will calculate the number of shipments per month.
The unique key for one shipment is a combination of shipment_id and sub_id.
Output the year_month in format YYYY-MM and the number of shipments in that month.
COMPANY : AMAZON
*/
SELECT
    COUNT(CONCAT(SHIPMENT_ID, SUB_ID)) as shipment_count,
    CONCAT(EXTRACT(YEAR FROM SHIPMENT_DATE), '-', EXTRACT(MONTH FROM SHIPMENT_DATE)) AS YEAR_MONTH
FROM AMAZON_SHIPMENT
GROUP BY YEAR_MONTH;

/*Find the average number of bathrooms and bedrooms for each city’s property types.
Output the result along with the city name and the property type.
COMPANY : AIRBNB
*/
SELECT
    AVG(BATHROOMS),
    AVG(BEDROOMS),
    CITY,
    PROPERTY_TYPE
FROM AIRBNB_SEARCH_DETAILS
GROUP BY PROPERTY_TYPE,CITY;

/*Find the most profitable company from the financial sector.
Output the result along with the continent.
COMPANY:FORBES
*/

WITH maxprofits AS
  (SELECT MAX(profits) AS max_profit
   FROM forbes_global_2010_2014
   WHERE sector = 'Financials')
SELECT company,
       continent
FROM forbes_global_2010_2014
JOIN maxprofits ON forbes_global_2010_2014.profits = maxprofits.max_profit
WHERE sector = 'Financials';

/*Count the number of user events performed by MacBookPro users.
Output the result along with the event name.
Sort the result based on the event count in the descending order
COMPANY :APPLE
*/
SELECT
    COUNT(USER_ID),
    EVENT_NAME
FROM PLAYBOOK_EVENTS
WHERE DEVICE = 'macbook pro'
GROUP BY EVENT_NAME
ORDER BY COUNT(USER_ID) DESC;

/*Find the inspection date and risk category (pe_description) of facilities named 'STREET CHURROS' that received a score below 95
COMPANY : City of Los Angeles
*/
SELECT
    ACTIVITY_DATE,
    PE_DESCRIPTION
FROM LOS_ANGELES_RESTAURANT_HEALTH_INSPECTIONS
WHERE FACILITY_NAME = 'STREET CHURROS' AND SCORE < 95
GROUP BY PE_DESCRIPTION, ACTIVITY_DATE