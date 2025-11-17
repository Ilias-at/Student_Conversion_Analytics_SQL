select 
Round(avg (date_diff_watch_purch),2) as Av_watch_purch

from (select si.student_id,datediff(sp.first_date_purchased,se.first_date_watched) as date_Diff_watch_Purch
from student_info si 
left JOIN(
        SELECT student_id, MIN(date_watched) AS first_date_watched
        FROM student_engagement 
        GROUP BY student_id
    ) se ON si.student_id = se.student_id
    
    left join ( select student_id, min(date_purchased) as First_date_purchased
    from student_purchases
    group by  student_id) sp
    on  si.student_id =sp.student_id
    where se.first_date_watched is not null
    and sp.first_date_purchased is not null 
    and se.first_date_watched <= sp.first_date_purchased
 ) as Sub 