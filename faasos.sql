-- no iof rolls ordered
select count(order_id) from customer_orders;

-- no of unique customer order
select count(distinct customer_id) from customer_orders;

-- successfull order delivered by each driver
select driver_id, count(distinct order_id) as no_of_sdo from driver_order where cancellation is null group by driver_id;

-- no of each type of rolls delivered
select c.roll_id, count(d.order_id) as no_delv from driver_order as d
left join customer_orders as c on c.order_id = d.order_id
where d.cancellation is null group by roll_id;

-- no of veg and non veg roll order by each customer
SELECT customer_id, 
    SUM(IF(roll_id = 2, 1, 0)) AS veg_roll, 
    SUM(IF(roll_id = 1, 1, 0)) AS non_veg_roll 
FROM customer_orders 
GROUP BY customer_id;

-- max no of roll delivered in single order
select d.order_id, count(c.order_id) from driver_order as d 
join customer_orders as c on c.order_id = d.order_id where d.cancellation is null group by d.order_id;

-- for each customer no. of devlivered roll with at least 1 change and with no change
SELECT 
  c.customer_id, 
  SUM(IF(
      (c.not_include_items IS NOT NULL AND c.not_include_items != '') OR 
      (c.extra_items_included IS NOT NULL AND c.extra_items_included != ''), 1, 0)) AS at_least_1_change,
  SUM(IF(c.not_include_items IS NULL AND c.extra_items_included IS NULL, 1, 0)) AS no_change
FROM customer_orders AS c
JOIN driver_order AS d ON d.order_id = c.order_id
WHERE d.cancellation IS NULL
GROUP BY c.customer_id;

-- how many delivered rolls had both exclusion and include
SELECT SUM(IF(c.not_include_items IS not NULL AND c.extra_items_included IS not NULL, 1, 0)) as both_e_i_delv
FROM customer_orders AS c
JOIN driver_order AS d ON d.order_id = c.order_id
WHERE d.cancellation IS NULL
;

-- no of rolls orderd for each hour of a day
SELECT 
  CONCAT(LPAD(HOUR(order_date), 2, '0'), '-', LPAD(HOUR(order_date) + 1, 2, '0')) AS hour_range,
  COUNT(*) AS total_orders
FROM customer_orders
GROUP BY hour_range
ORDER BY hour_range;

-- no of order for each day of week
SELECT 
  DAYname(order_date) AS day_of_week,
  COUNT(*) AS total_orders
FROM customer_orders
GROUP BY day_of_week;

-- avg time in minutes taken taken by driver to arrive fassos HQ
select d.driver_id, 
avg(timestampdiff(minute, c.order_date, d.pickup_time)) as avg_pickuptime 
from driver_order as d 
inner join customer_orders as c on c.order_id = d.order_id 
group by d.driver_id
;

-- avg distance travelled for each customer
select c.customer_id, round(avg(d.distance),1) as avg_dist_travelled from customer_orders as c
left join driver_order as d on d.order_id = c.order_id 
group by c.customer_id;

-- diff btw longest and the shortest delivery time for each order
SELECT 
  c.order_id, 
  MAX(TIMESTAMPDIFF(MINUTE, c.order_date, d.pickup_time)) - 
  MIN(TIMESTAMPDIFF(MINUTE, c.order_date, d.pickup_time)) AS diff_l_s
FROM customer_orders AS c
LEFT JOIN driver_order AS d ON d.order_id = c.order_id
WHERE d.pickup_time IS NOT NULL
and c.order_date is not null
and d.cancellation is null
GROUP BY c.order_id;

SELECT 
  c.order_id,
  MAX(d.duration) - MIN(d.duration) AS delivery_time_diff
FROM customer_orders c
inner JOIN driver_order as d ON c.order_id = d.order_id
WHERE d.cancellation IS NULL AND d.duration IS NOT NULL
GROUP BY c.order_id;

-- avg speed im km/h of each driver
select driver_id, round(avg((distance/duration)*60),2) as avg_speed from driver_order
where cancellation is null 
and distance is not null
and duration is not null
group by driver_id;

