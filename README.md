# Calculating Free-to-Paid Conversion Rate with SQL

##  Executive Summary
This project analyzes student behavior on the 365 Data Science platform, focusing on the journey from registration to first engagement and conversion to paid subscriptions. The goal is to calculate key metrics to evaluate platform monetization efficiency and provide actionable insights for improving onboarding and conversion.

##  Business Problem
We do not know the conversion rate from students who started watching free content to students who subscribed to the platform.
This creates a gap in understanding content effectiveness, subscription strategy, and revenue optimization.

##  Objective

**Main Objective:**  
Calculate the Free-to-Paid Conversion Rate for students who engaged with content, and analyze subscription patterns to understand how long it takes for a student to convert to a paying subscriber. 
This helps improve user experience and increase revenue.

##  Available Data
| Table         | Description                                 | Key Relationships                                                                      |
| ------------- | ------------------------------------------- | -------------------------------------------------------------------------------------- |
| student_info     | Student information and registration dates  | `student_id` ↔ `engagements.student_id` <br> `student_id` ↔ `subscriptions.student_id` |
| student_engagement  | Dates when students interacted with content | -                                                                                      |
| student_purchases | Dates when students purchased subscriptions | -                                                                                      |

<img width="500" height="800" alt="venndiagram" src="https://github.com/user-attachments/assets/099e5311-7ec7-4d0d-b48f-09281723b81d" />


##  Methodology
**Data Exploration** (EDA)

The initial analysis focused on understanding student behavior across the three available datasets.
Key insights aimed to uncover:

- Free-to-Paid Conversion Rate
- Average duration from Registration → First Engagement
- Average duration from First Engagement → First Purchase

This step made it possible to identify missing values, students who engaged but did not purchase, outliers in engagement or purchase timelines, and the logical relationships between the datasets.

**Dataset Creation**

To build the analytical dataset, the tables were joined using `student_id`.
The earliest engagement and earliest purchase dates were extracted using `MIN()`.
Date differences were calculated using `DATEDIFF()` to measure:
- Time from registration to first watch
- Time from first watch to first purchase

**KPI Computation**

The key performance indicators calculated for the project include:

- Free-to-Paid Conversion Rate
- Average time from Registration → First Watch
- Average time from First Watch → Purchase

These KPIs provide a clear understanding of student engagement behavior and monetization efficiency.

## SQL Code Used for Data Analysis

   

```sql
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
```


<img width="850" height="160" alt="Capture d&#39;écran 2025-11-17 130529" src="https://github.com/user-attachments/assets/b47657ae-1960-40a9-9653-d40cda2987b8" />



## Interpretation of Results

**Free-to-Paid Conversion Rate** (~11%)

- Only a small fraction of students who watch lectures subscribe. This indicates an opportunity to improve onboarding, engagement, and early motivation strategies.

**Time from Registration → First Engagement** (3–4 days on average)

- Most students start learning quickly, showing initial interest. Minor friction can be reduced with clearer guidance, personalized learning paths, and motivational nudges.

<img width="579" height="437" alt="watch" src="https://github.com/user-attachments/assets/1fcfb540-1968-4e89-8d2f-21cd2fa646da" />

**Time from First Engagement → Purchase** (~26 days on average)

- Students take time to commit, reflecting exploration before subscription. Strategic interventions like targeted promotions or reminders can accelerate conversion.
  
<img width="596" height="437" alt="purch" src="https://github.com/user-attachments/assets/1737cccb-fb8e-4211-994a-c23007a5da14" />

## Recommendations
* Enhance onboarding guidance for beginners.  
* Implement early nudges and personalized reminders.  
* Introduce targeted promotions to shorten time to purchase for hesitant users.




