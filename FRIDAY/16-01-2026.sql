/*
Which user flagged the most distinct videos that ended up approved by YouTube? Output, in one column, their full name or names in case of a tie. In the user's full name, include a space between the first and the last name.
*/
WITH users AS (
    SELECT
        CONCAT(u.user_firstname, ' ', u.user_lastname) as name,
        COUNT(distinct u.video_id) AS flags_count
    FROM user_flags as u
    JOIN flag_review AS fr ON u.flag_id = fr.flag_id
    WHERE fr.reviewed_by_yt = TRUE and LOWER(fr.reviewed_outcome) = 'approved'
    GROUP BY name
),
video_rank AS (
    SELECT
        name,
        flags_count,
        DENSE_RANK() OVER(ORDER BY flags_count desc) AS rank_cust -- Dense rank , in case thers is a tie between user flags 
    FROM users
)
SELECT name FROM video_rank where rank_cust=1 ;