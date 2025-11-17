SELECT 
    ROUND(Avg (date_diff_reg_watch), 2) AS AV_Reg_Watch
FROM
    (SELECT 
        si.student_id,
            DATEDIFF(se.first_date_watched, si.date_registered) AS date_diff_reg_watch
    FROM
        student_info si
    LEFT JOIN (SELECT 
       student_id, MIN(date_watched) AS first_date_watched
    FROM
        student_engagement se
    GROUP BY student_id) se 
    ON si.student_id = se.student_id
    WHERE
        se.first_date_watched IS NOT NULL) AS Sub