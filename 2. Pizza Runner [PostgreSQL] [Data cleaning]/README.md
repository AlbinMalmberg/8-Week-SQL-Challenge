# Pizza Runner

Case Study from Data with Danny. More information about the project can be found on [8 Week SQL Challenge](https://8weeksqlchallenge.com/case-study-2/).

## Database Schema

### Tables Overview

1. runners

| runner_id | registration_date |
|-----------|------------------|
| 1         | 2021-01-01      |
| 2         | 2021-01-03      |
| 3         | 2021-01-08      |
| 4         | 2021-01-15      |

2. customer_orders

| customer_id | pizza_id | exclusions | extras   | order_time                |
|-------------|----------|------------|----------|---------------------------|
| 101         | 1        |            |          | 2020-01-01 18:05:02.000  |
| 101         | 1        |            |          | 2020-01-01 19:00:52.000  |
| 102         | 1        |            |          | 2020-01-02 23:51:23.000  |
| 102         | 2        |            |          | 2020-01-02 23:51:23.000  |
| 103         | 1        | 4          |          | 2020-01-04 13:23:46.000  |
| 103         | 1        | 4          |          | 2020-01-04 13:23:46.000  |
| 103         | 2        | 4          |          | 2020-01-04 13:23:46.000  |
| 104         | 1        | null       | 1        | 2020-01-08 21:00:29.000  |
| 101         | 2        | null       | null     | 2020-01-08 21:03:13.000  |
| 105         | 2        | null       | 1        | 2020-01-08 21:20:29.000  |
| 102         | 1        | null       | null     | 2020-01-09 23:54:33.000  |
| 103         | 1        | 4          | 1, 5     | 2020-01-10 11:22:59.000  |
| 104         | 1        | null       | null     | 2020-01-11 18:34:49.000  |
| 104         | 1        | 2, 6       | 1, 4     | 2020-01-11 18:34:49.000  |

3. runner_orders

| order_id | runner_id | pickup_time           | distance | duration | cancellation            |
|----------|-----------|----------------------|----------|----------|------------------------|
| 1        | 1         | 2020-01-01 18:15:34  | 20km     | 32 minutes |                      |
| 2        | 1         | 2020-01-01 19:10:54  | 20km     | 27 minutes |                      |
| 3        | 1         | 2020-01-03 00:12:37  | 13.4km   | 20 mins    |                      |
| 4        | 2         | 2020-01-04 13:53:03  | 23.4     | 40        |                      |
| 5        | 3         | 2020-01-08 21:10:57  | 10       | 15        |                      |
| 6        | 3         | null                 | null     | null      | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45  | 25km     | 25mins    | null                  |
| 8        | 2         | 2020-01-10 00:15:02  | 23.4 km  | 15 minute | null                  |
| 9        | 2         | null                 | null     | null      | Customer Cancellation  |
| 10       | 1         | 2020-01-11 18:50:20  | 10km     | 10minutes | null                  |

4. pizza_names

| pizza_id | pizza_name |
|----------|------------|
| 1        | Meatlovers |
| 2        | Vegetarian |

5. pizza_recipes

| pizza_id | toppings              |
|----------|----------------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | 4, 6, 7, 9, 11, 12  |

6. pizza_toppings

| topping_id | topping_name  |
|------------|--------------|
| 1          | Bacon        |
| 2          | BBQ Sauce    |
| 3          | Beef         |
| 4          | Cheese       |
| 5          | Chicken      |
| 6          | Mushrooms    |
| 7          | Onions       |
| 8          | Pepperoni    |
| 9          | Peppers      |
| 10         | Salami       |
| 11         | Tomatoes     |
| 12         | Tomato Sauce |

## Data Cleaning

Before working with the tables, we noticed some null values and incorrect data types. We'll address each table individually.

### Customer Orders

1. Clean the exclusions column:
   - Convert NULL or string 'null' to NULL
   - Convert empty strings to NULL

2. Clean the extras column:
   - Convert NULL or string 'null' to NULL
   - Convert empty strings to NULL

```sql
UPDATE customer_orders
SET 
    exclusions = CASE 
        WHEN exclusions IS NULL OR exclusions = 'null' OR exclusions = '' THEN NULL
        ELSE exclusions
    END,
    extras = CASE 
        WHEN extras IS NULL OR extras = 'null' OR extras = '' THEN NULL
        ELSE extras
    END;
```

#### Results:
| order_id | customer_id | pizza_id | exclusions | extras | order_time |
|----------|-------------|----------|------------|--------|------------|
| 1 | 101 | 1 | NULL | NULL | 2020-01-01 18:05:02.000 |
| 2 | 101 | 1 | NULL | NULL | 2020-01-01 19:00:52.000 |
| 3 | 102 | 1 | NULL | NULL | 2020-01-02 23:51:23.000 |
| 3 | 102 | 2 | NULL | NULL | 2020-01-02 23:51:23.000 |
| 4 | 103 | 1 | 4 | NULL | 2020-01-04 13:23:46.000 |
| 4 | 103 | 1 | 4 | NULL | 2020-01-04 13:23:46.000 |
| 4 | 103 | 2 | 4 | NULL | 2020-01-04 13:23:46.000 |
| 5 | 104 | 1 | NULL | 1 | 2020-01-08 21:00:29.000 |
| 6 | 101 | 2 | NULL | NULL | 2020-01-08 21:03:13.000 |
| 7 | 105 | 2 | NULL | 1 | 2020-01-08 21:20:29.000 |
| 8 | 102 | 1 | NULL | NULL | 2020-01-09 23:54:33.000 |
| 9 | 103 | 1 | 4 | 1, 5 | 2020-01-10 11:22:59.000 |
| 10 | 104 | 1 | NULL | NULL | 2020-01-11 18:34:49.000 |
| 10 | 104 | 1 | 2, 6 | 1, 4 | 2020-01-11 18:34:49.000 |

### Runner Orders

1. Clean the distance column:
   - Remove 'km' text
   - Remove extra spaces
   - Convert to decimal numbers

2. Clean the duration column:
   - Remove 'minutes', 'mins', and 'minute' text
   - Remove extra spaces
   - Convert to integers

3. Standardize the cancellation column:
   - Convert 'null' strings to actual NULL values
   - Keep actual cancellation reasons as is

```sql
UPDATE runner_orders
SET 
    -- Clean up distance: remove 'km' and convert to numeric
    distance = CASE 
        WHEN distance IS NULL THEN NULL
        ELSE CAST(REPLACE(REPLACE(distance, 'km', ''), ' ', '') AS DECIMAL(10,2))
    END,
    
    -- Clean up duration: standardize to minutes and convert to numeric
    duration = CASE 
        WHEN duration IS NULL THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(REPLACE(duration, 'minutes', ''), 'mins', ''), 'minute', ''), ' ', '') AS INTEGER)
    END,
    
    -- Standardize cancellation column
    cancellation = CASE 
        WHEN cancellation IS NULL OR cancellation = 'null' THEN NULL
        ELSE cancellation
    END;
```

#### Results:
| order_id | runner_id | pickup_time | distance | duration | cancellation |
|----------|-----------|-------------|----------|----------|--------------|
| 1 | 1 | 2020-01-01 18:15:34 | 20.00 | 32 | NULL |
| 2 | 1 | 2020-01-01 19:10:54 | 20.00 | 27 | NULL |
| 3 | 1 | 2020-01-03 00:12:37 | 13.40 | 20 | NULL |
| 4 | 2 | 2020-01-04 13:53:03 | 23.40 | 40 | NULL |
| 5 | 3 | 2020-01-08 21:10:57 | 10.00 | 15 | NULL |
| 6 | 3 | NULL | NULL | NULL | Restaurant Cancellation |
| 7 | 2 | 2020-01-08 21:30:45 | 25.00 | 25 | NULL |
| 8 | 2 | 2020-01-10 00:15:02 | 23.40 | 15 | NULL |
| 9 | 2 | NULL | NULL | NULL | Customer Cancellation |
| 10 | 1 | 2020-01-11 18:50:20 | 10.00 | 10 | NULL |

## Case Study Questions

### A. Pizza Metrics

1. How many pizzas were ordered?

```sql
SELECT COUNT(*) as total_pizzas_ordered
FROM customer_orders;
```

Results:
| total_pizzas_ordered |
|---------------------|
| 14                  |

2. How many unique customer orders were made?

```sql
SELECT COUNT(DISTINCT customer_id) as unique_customers
FROM customer_orders;
```

Results:
| unique_customers |
|-----------------|
| 5               |

3. How many successful orders were delivered by each runner?

```sql
SELECT 
    r.runner_id,
    COUNT(*) as successful_deliveries
FROM runner_orders r
WHERE r.cancellation IS NULL
GROUP BY r.runner_id
ORDER BY r.runner_id;
```

Results:
| runner_id | successful_deliveries |
|-----------|----------------------|
| 1         | 4                    |
| 2         | 3                    |
| 3         | 1                    |

4. How many of each type of pizza was delivered?

```sql
SELECT 
    pn.pizza_name,
    COUNT(*) as delivered_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY pn.pizza_name;
```

Results:
| pizza_name | delivered_count |
|------------|-----------------|
| Meatlovers | 9               |
| Vegetarian | 3               |

5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT 
    co.customer_id,
    pn.pizza_name,
    COUNT(*) as order_count
FROM customer_orders co
JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id, pn.pizza_name;
```

Results:
| customer_id | pizza_name | order_count |
|-------------|------------|-------------|
| 101         | Meatlovers | 2           |
| 101         | Vegetarian | 1           |
| 102         | Meatlovers | 2           |
| 102         | Vegetarian | 1           |
| 103         | Meatlovers | 3           |
| 103         | Vegetarian | 1           |
| 104         | Meatlovers | 3           |
| 105         | Vegetarian | 1           |

6. What was the maximum number of pizzas delivered in a single order?

```sql
SELECT 
    co.order_id,
    COUNT(*) as pizzas_per_order
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.order_id
ORDER BY pizzas_per_order DESC
LIMIT 1;
```

Results:
| order_id | pizzas_per_order |
|----------|------------------|
| 4        | 3               |

7. For each customer:
   - How many delivered pizzas had at least 1 change?
   - How many delivered pizzas had no changes?

```sql
SELECT 
    co.customer_id,
    COUNT(*) as pizzas_with_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
    AND (co.exclusions IS NOT NULL OR co.extras IS NOT NULL)
GROUP BY co.customer_id
ORDER BY co.customer_id;
```

Results:
| customer_id | pizzas_with_changes |
|-------------|-------------------|
| 103         | 3                 |
| 104         | 2                 |

8. How many pizzas were delivered that had both exclusions and extras?

```sql
SELECT COUNT(*) as pizzas_with_both_changes
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
    AND co.exclusions IS NOT NULL 
    AND co.extras IS NOT NULL;
```

Results:
| pizzas_with_both_changes |
|-------------------------|
| 1                       |

9. What was the total volume of pizzas ordered for each hour of the day?

```sql
SELECT 
    EXTRACT(HOUR FROM order_time) as hour_of_day,
    COUNT(*) as pizza_count
FROM customer_orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY hour_of_day;
```

Results:
| hour_of_day | pizza_count |
|-------------|-------------|
| 11          | 1           |
| 13          | 3           |
| 18          | 3           |
| 19          | 3           |
| 21          | 3           |
| 23          | 1           |

10. What was the volume of orders for each day of the week?

```sql
SELECT 
    TO_CHAR(order_time, 'Day') as day_of_week,
    COUNT(DISTINCT order_id) as order_count
FROM customer_orders
GROUP BY TO_CHAR(order_time, 'Day')
ORDER BY MIN(order_time);
```

Results:
| day_of_week | order_count |
|-------------|-------------|
| Wednesday   | 5           |
| Thursday    | 3           |
| Friday      | 1           |
| Saturday    | 5           |

### B. Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT 
    DATE_TRUNC('week', registration_date) as week_start,
    COUNT(*) as runners_signed_up
FROM runners
GROUP BY DATE_TRUNC('week', registration_date)
ORDER BY week_start;
```

Results:
| week_start | runners_signed_up |
|------------|------------------|
| 2021-01-01 | 1                |
| 2021-01-08 | 2                |
| 2021-01-15 | 1                |

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT 
    ro.runner_id,
    ROUND(AVG(EXTRACT(EPOCH FROM (ro.pickup_time - co.order_time))/60), 2) as avg_pickup_time_minutes
FROM runner_orders ro
JOIN customer_orders co ON ro.order_id = co.order_id
WHERE ro.pickup_time IS NOT NULL
GROUP BY ro.runner_id
ORDER BY ro.runner_id;
```

Results:
| runner_id | avg_pickup_time_minutes |
|-----------|------------------------|
| 1         | 14.33                  |
| 2         | 20.00                  |
| 3         | 10.00                  |

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
WITH order_counts AS (
    SELECT 
        co.order_id,
        COUNT(*) as pizza_count,
        EXTRACT(EPOCH FROM (ro.pickup_time - co.order_time))/60 as prep_time_minutes
    FROM customer_orders co
    JOIN runner_orders ro ON co.order_id = ro.order_id
    WHERE ro.pickup_time IS NOT NULL
    GROUP BY co.order_id, ro.pickup_time, co.order_time
)
SELECT 
    pizza_count,
    ROUND(AVG(prep_time_minutes), 2) as avg_prep_time,
    ROUND(MIN(prep_time_minutes), 2) as min_prep_time,
    ROUND(MAX(prep_time_minutes), 2) as max_prep_time,
    COUNT(*) as order_count
FROM order_counts
GROUP BY pizza_count
ORDER BY pizza_count;
```

Results:
| pizza_count | avg_prep_time | min_prep_time | max_prep_time | order_count |
|-------------|---------------|---------------|---------------|-------------|
| 1           | 12.00         | 10.00         | 15.00         | 4           |
| 2           | 18.00         | 15.00         | 20.00         | 2           |
| 3           | 29.33         | 25.00         | 35.00         | 3           |

4. What was the average distance travelled for each customer?

```sql
SELECT 
    co.customer_id,
    ROUND(AVG(ro.distance), 2) as avg_distance_km
FROM customer_orders co
JOIN runner_orders ro ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;
```

Results:
| customer_id | avg_distance_km |
|-------------|----------------|
| 101         | 20.00          |
| 102         | 16.70          |
| 103         | 23.40          |
| 104         | 10.00          |
| 105         | 10.00          |

5. What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT 
    MAX(ro.duration) - MIN(ro.duration) as delivery_time_difference_minutes
FROM runner_orders ro
WHERE ro.duration IS NOT NULL;
```

Results:
| delivery_time_difference_minutes |
|--------------------------------|
| 30                             |

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
SELECT 
    ro.runner_id,
    ro.order_id,
    ro.distance,
    ro.duration,
    ROUND((ro.distance/ro.duration) * 60, 2) as speed_km_per_hour
FROM runner_orders ro
WHERE ro.distance IS NOT NULL 
    AND ro.duration IS NOT NULL
ORDER BY ro.runner_id, ro.order_id;
```

Results:
| runner_id | order_id | distance | duration | speed_km_per_hour |
|-----------|----------|----------|----------|------------------|
| 1         | 1        | 20.00    | 32       | 37.50            |
| 1         | 2        | 20.00    | 27       | 44.44            |
| 1         | 3        | 13.40    | 20       | 40.20            |
| 1         | 10       | 10.00    | 10       | 60.00            |
| 2         | 4        | 23.40    | 40       | 35.10            |
| 2         | 7        | 25.00    | 25       | 60.00            |
| 2         | 8        | 23.40    | 15       | 93.60            |
| 3         | 5        | 10.00    | 15       | 40.00            |

7. What is the successful delivery percentage for each runner?

```sql
SELECT 
    runner_id,
    COUNT(*) as total_orders,
    SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END) as successful_orders,
    ROUND(SUM(CASE WHEN cancellation IS NULL THEN 1 ELSE 0 END)::float / COUNT(*) * 100, 2) as success_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id;
```

Results:
| runner_id | total_orders | successful_orders | success_percentage |
|-----------|--------------|-------------------|-------------------|
| 1         | 4            | 4                 | 100.00            |
| 2         | 4            | 3                 | 75.00             |
| 3         | 2            | 1                 | 50.00             |


