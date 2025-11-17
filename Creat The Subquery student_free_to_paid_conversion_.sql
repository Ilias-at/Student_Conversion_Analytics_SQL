SELECT 
    si.student_id,
    si.date_registered,
    se.first_date_watched,
    sp.first_date_purchased,
    DATEDIFF(se.first_date_watched,
            si.date_registered) AS Date_Diff_Reg_Watch,
    DATEDIFF(sp.first_date_purchased,
            se.first_date_watched) AS Date_Diff_Watch_Purch
FROM
    student_info si
        LEFT JOIN
    (SELECT 
        student_id, MIN(date_watched) AS First_date_watched
    FROM
        student_engagement
    GROUP BY student_id) se ON si.student_id = se.student_id
        LEFT JOIN
    (SELECT 
        student_id, MIN(date_purchased) AS first_date_purchased
    FROM
        student_purchases
    GROUP BY student_id) sp ON si.student_id = sp.student_id
WHERE se.first_date_watched IS NOT NULL 
  AND (sp.first_date_purchased IS NULL OR se.first_date_watched <= sp.first_date_purchased)
