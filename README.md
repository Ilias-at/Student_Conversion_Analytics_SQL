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
| students      | Student information and registration dates  | `student_id` ↔ `engagements.student_id` <br> `student_id` ↔ `subscriptions.student_id` |
| engagements   | Dates when students interacted with content | -                                                                                      |
| subscriptions | Dates when students purchased subscriptions | -                                                                                      |

<img width="500" height="800" alt="venndiagram" src="https://github.com/user-attachments/assets/099e5311-7ec7-4d0d-b48f-09281723b81d" />


## 4. Methodology
1. **Data Exploration:** Count total students, engagements, subscriptions; check for missing values.



