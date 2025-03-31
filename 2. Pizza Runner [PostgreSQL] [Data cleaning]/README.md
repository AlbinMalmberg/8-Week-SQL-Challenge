# Pizza Runner
Case Study from Data with Danny, more information about the project can be found on https://8weeksqlchallenge.com/case-study-2/

<details>
<summary>Click to show tables</summary>

1. runners  
    |runner_id|registration_date|
    |---------|-----------------|
    |1|2021-01-01|
    |2|2021-01-03|
    |3|2021-01-08|
    |4|2021-01-15|
2. customer_orders
    |customer_id|pizza_id|exclusions|extras|order_time|
    |-----------|--------|----------|------|----------|
    |101|1|||2020-01-01 18:05:02.000|
    |101|1|||2020-01-01 19:00:52.000|
    |102|1|||2020-01-02 23:51:23.000|
    |102|2|||2020-01-02 23:51:23.000|
    |103|1|4||2020-01-04 13:23:46.000|
    |103|1|4||2020-01-04 13:23:46.000|
    |103|2|4||2020-01-04 13:23:46.000|
    |104|1|null|1|2020-01-08 21:00:29.000|
    |101|2|null|null|2020-01-08 21:03:13.000|
    |105|2|null|1|2020-01-08 21:20:29.000|
    |102|1|null|null|2020-01-09 23:54:33.000|
    |103|1|4|1, 5|2020-01-10 11:22:59.000|
    |104|1|null|null|2020-01-11 18:34:49.000|
    |104|1|2, 6|1, 4|2020-01-11 18:34:49.000|
3. runner_orders
    |order_id|runner_id|pickup_time|distance|duration|cancellation|
    |--------|---------|-----------|--------|--------|------------|
    |1|1|2020-01-01 18:15:34|20km|32 minutes||
    |2|1|2020-01-01 19:10:54|20km|27 minutes||
    |3|1|2020-01-03 00:12:37|13.4km|20 mins||
    |4|2|2020-01-04 13:53:03|23.4|40||
    |5|3|2020-01-08 21:10:57|10|15||
    |6|3|null|null|null|Restaurant Cancellation|
    |7|2|2020-01-08 21:30:45|25km|25mins|null|
    |8|2|2020-01-10 00:15:02|23.4 km|15 minute|null|
    |9|2|null|null|null|Customer Cancellation|
    |10|1|2020-01-11 18:50:20|10km|10minutes|null|
4. pizza_names
    |pizza_id|pizza_name|
    |--------|----------|
    |1|Meatlovers|
    |2|Vegetarian|
5. pizza_recipes;
    |pizza_id|toppings|
    |--------|--------|
    |1|1, 2, 3, 4, 5, 6, 8, 10|
    |2|4, 6, 7, 9, 11, 12|
6. pizza_toppings
    |topping_id|topping_name|
    |----------|------------|
    |1|Bacon|
    |2|BBQ Sauce|
    |3|Beef|
    |4|Cheese|
    |5|Chicken|
    |6|Mushrooms|
    |7|Onions|
    |8|Pepperoni|
    |9|Peppers|
    |10|Salami|
    |11|Tomatoes|
    |12|Tomato Sauce|






</details>

# Data Cleaning

Entity Relationship Diagram: <br>
![image](https://user-images.githubusercontent.com/85653222/230747617-2bf4beb7-52c4-442e-b18a-5302fdd989b0.png)
