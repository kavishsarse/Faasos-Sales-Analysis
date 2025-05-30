# Faasos Rolls Dataset Analysis with SQL
## Overview
This project utilizes a sample dataset from Faasos, a leading quick-service restaurant chain known for its signature rolls and meals. The goal is to perform data analysis using SQL queries. We have five different data tables available for analysis, and by joining them as required, we aim to derive meaningful insights and solutions related to Faasos' operations and customer preferences.
## Requirements
Database: MySQL
Dataset: Created Table using queries
Tables: customers_orders, driver_orders, drivers, ingreidents, rolls, rolls_recipies 

## Sample Queries

-- No of unique customer order ?

select count(distinct customer_id) from customer_orders;


-- No of veg and non veg roll order by each customer ?

SELECT customer_id, 
    SUM(IF(roll_id = 2, 1, 0)) AS veg_roll, 
    SUM(IF(roll_id = 1, 1, 0)) AS non_veg_roll 
FROM customer_orders 
GROUP BY customer_id;
