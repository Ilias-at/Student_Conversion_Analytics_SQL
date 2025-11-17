SELECT 
    -- 1) Conversion Rate
    (
        SELECT 
            ROUND(
                100 * SUM(CASE WHEN first_date_purchased IS NOT NULL THEN 1 ELSE 0 END) 
                / COUNT(*), 2
            )
        FROM (
            SELECT 
                si.student_id,
                se.first_date_watched,
                sp.first_date_purchased
            FROM student_info si
            LEFT JOIN (
                SELECT student_id, MIN(date_watched) AS first_date_watched
                FROM student_engagement
                GROUP BY student_id
            ) se ON se.student_id = si.student_id
            LEFT JOIN (
                SELECT student_id, MIN(date_purchased) AS first_date_purchased
                FROM student_purchases
                GROUP BY student_id
            ) sp ON sp.student_id = si.student_id
            WHERE se.first_date_watched IS NOT NULL
              AND (sp.first_date_purchased IS NULL 
                   OR se.first_date_watched <= sp.first_date_purchased)
        ) AS sub1
    ) AS Conversion_Rate,


    -- 2) Average Registration → First Watch
    (
        SELECT 
            ROUND(AVG(DATEDIFF(se.first_date_watched, si.date_registered)), 2)
        FROM student_info si
        LEFT JOIN (
            SELECT student_id, MIN(date_watched) AS first_date_watched
            FROM student_engagement
            GROUP BY student_id
        ) se ON si.student_id = se.student_id
        WHERE se.first_date_watched IS NOT NULL
    ) AS Avg_Reg_to_Watch,


    -- 3) Average First Watch → First Purchase
    (
        SELECT 
            ROUND(AVG(DATEDIFF(sp.first_date_purchased, se.first_date_watched)), 2)
        FROM student_info si
        LEFT JOIN (
            SELECT student_id, MIN(date_watched) AS first_date_watched
            FROM student_engagement
            GROUP BY student_id
        ) se ON si.student_id = se.student_id
        LEFT JOIN (
            SELECT student_id, MIN(date_purchased) AS first_date_purchased
            FROM student_purchases
            GROUP BY student_id
        ) sp ON si.student_id = sp.student_id
        WHERE se.first_date_watched IS NOT NULL
          AND sp.first_date_purchased IS NOT NULL
          AND se.first_date_watched <= sp.first_date_purchased
    ) AS Avg_Watch_to_Purchase;
