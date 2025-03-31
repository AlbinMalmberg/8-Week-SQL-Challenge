# Dannys Diner 

Case Study from Data with Danny, more information about the project can be found on https://8weeksqlchallenge.com/case-study-1/

Entity Relationship Diagram:

![alt text](image.png)

1. What is the total amount each customer spent at the restaurant?
    ```sql
    SELECT 
        s.customer_id, 
        SUM(m.price) AS total_spent
    FROM sales s
    JOIN menu m 
        ON s.product_id = m.product_id 
    GROUP BY s.customer_id;
* Answer
    |customer_id|total_spent|
    |-----------|-----------|
    |A|76|
    |B|74|
    |C|36|


2. How many days has each customer visited the restaurant?
   ```sql
    SELECT 
        customer_id, 
        COUNT(DISTINCT order_date) as visists
    FROM sales 
    GROUP BY customer_id;
* Answer 
    |customer_id|visists|
    |-----------|-------|
    |A|4|
    |B|6|
    |C|2|

3. What was the first item from the menu purchased by each customer?
    ```sql
    SELECT DISTINCT 
        s.customer_id, 
        MIN(s.order_date), 
        m.product_name  
    FROM sales s
    JOIN menu m ON s.product_id = m.product_id 
    GROUP BY customer_id;
* Answer
    |customer_id|MIN(s.order_date)|product_name|
    |-----------|-----------------|------------|
    |A|2021-01-01|sushi|
    |B|2021-01-01|curry|
    |C|2021-01-01|ramen|
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
    ```sql
    SELECT 
        m.product_name, 
        COUNT(s.product_id) AS most_sales
    FROM sales s
    JOIN menu m ON m.product_id = s.product_id
    GROUP BY s.product_id
    ORDER BY most_sales DESC
    LIMIT 1;
* Answer 
    |product_name|most_sales|
    |------------|----------|
    |ramen|8|


5. Which item was the most popular for each customer? 
    ```sql
    SELECT 
        customer_id, 
        product_name
    FROM (
        SELECT 
            m.product_name, 
            s.customer_id, 
            COUNT(s.product_id), 
            s.product_id, 
            DENSE_RANK() OVER (
                PARTITION BY s.customer_id 
                ORDER BY COUNT(s.customer_id)
            ) AS rank 
        FROM 
            sales s 
        JOIN 
            menu m ON m.product_id = s.product_id
        GROUP BY 
            s.customer_id, s.product_id 
    )
    WHERE 
        rank = 1
    ORDER BY 
        customer_id;   
* Answer 
    |customer_id|product_name|
    |-----------|------------|
    |A|sushi|
    |B|sushi|
    |B|curry|
    |B|ramen|
    |C|ramen|


6. Which item was the most popular for each customer?
    ```sql
    WITH joined_member AS (
        SELECT 
            m.customer_id, 
            m.join_date, 
            s.order_date, 
            ROW_NUMBER() OVER (
                PARTITION BY s.customer_id 
                ORDER BY s.order_date
            ) AS row_num, 
            s.product_id 
        FROM sales s
        JOIN members m 
            ON m.customer_id = s.customer_id 
        AND s.order_date > m.join_date
    )
    SELECT 
        j.customer_id, 
        m.product_name
    FROM joined_member j
    JOIN menu m 
        ON j.product_id = m.product_id
    WHERE row_num = 1
    ORDER BY j.customer_id ASC;
* Answer
    |customer_id|product_name|
    |-----------|------------|
    |A|ramen|
    |B|sushi|

7.  Which item was purchased first by the customer after they became a member?
    ```sql
    WITH joined_member AS (
        SELECT 
            m.customer_id, 
            m.join_date, 
            s.order_date, 
            DENSE_RANK() OVER (
                PARTITION BY m.customer_id 
                ORDER BY s.order_date DESC
            ) AS ranked, 
            s.product_id 
        FROM sales s
        JOIN members m 
            ON m.customer_id = s.customer_id 
        AND s.order_date < m.join_date
    )
    SELECT DISTINCT 
        j.customer_id, 
        m.product_name
    FROM joined_member j
    JOIN menu m 
        ON j.product_id = m.product_id
    WHERE ranked = 1
    ORDER BY j.customer_id ASC;
* Answer
    |customer_id|product_name|
    |-----------|------------|
    |A|sushi|
    |A|curry|
    |B|sushi|

8.  What is the total items and amount spent for each member before they became a member?
    ```sql
    SELECT 
        sales.customer_id, 
        COUNT(sales.product_id) AS total_items, 
        SUM(menu.price) AS total_sales
    FROM sales
    INNER JOIN members
        ON sales.customer_id = members.customer_id
        AND sales.order_date < members.join_date
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    GROUP BY sales.customer_id
    ORDER BY sales.customer_id;
* Answer
    |customer_id|total_items|total_sales|
    |-----------|-----------|-----------|
    |A|2|25|
    |B|3|40|

9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. 
    ```sql
    SELECT 
        s.customer_id,
        SUM(
            CASE
                WHEN m.product_name = 'sushi' THEN price * 20
                ELSE price * 10
            END
        ) AS points
    FROM sales s
    JOIN menu m 
        ON s.product_id = m.product_id
    GROUP BY s.customer_id;    
* Answer
    |customer_id|points|
    |-----------|------|
    |A|860|
    |B|940|
    |C|360|
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
    
    ```sql
    SELECT
    m.customer_id,
    SUM(CASE
        WHEN (
            (JULIANDAY(s.order_date) - JULIANDAY(m.join_date) BETWEEN 0 AND 6)
            OR (menu.product_name = 'sushi')  	)
        THEN menu.price *20
        ELSE menu.price *10 END) AS points
    FROM members m
    JOIN sales s ON s.customer_id = m.customer_id
    JOIN menu menu ON s.product_id = menu.product_id
    GROUP BY m.customer_id;
* Answer
    |customer_id|points|
    |-----------|------|
    |A|1370|
    |B|940|
