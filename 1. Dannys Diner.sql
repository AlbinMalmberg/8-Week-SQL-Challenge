1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, 
  SUM(m.price) AS total_spent
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id 
GROUP BY s.customer_id;



 2. How many days has each customer visited the restaurant?

 SELECT COUNT(DISTINCT order_date)
  FROM sales 
GROUP BY customer_id;


 3. What was the first item from the menu purchased by each customer?

 SELECT DISTINCT s.customer_id, MIN(s.order_date), m.product_name  
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id 
 GROUP BY customer_id;



4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, COUNT(s.product_id) AS most_sales
  FROM sales s
  JOIN menu m ON m.product_id = s.product_id
 GROUP BY s.product_id
 ORDER BY most_sales DESC
 LIMIT 1;


  5.Which item was the most popular for each customer?
  
SELECT customer_id, product_name
  FROM (
       SELECT 
             m.product_name, 
             s.customer_id, 
   	         count(s.product_id), 
             s.product_id, 
  	         DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY count(s.customer_id) ) AS rank 
  FROM sales s 
  JOIN menu m ON m.product_id = s.product_id
 GROUP BY s.customer_id, s.product_id )
 WHERE rank = 1
 ORDER BY customer_id;

--6.Which item was purchased first by the customer after they became a member?

WITH joined_member AS (
  SELECT 
    m.customer_id, 
    m.join_date, 
    s.order_date, 
    ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.ORDER_DATE) as row_num, s.product_id 
    FROM sales s
    JOIN members m ON m.customer_id = s.customer_id AND  s.order_date > m.join_date
)
SELECT j.customer_id, m.product_name
  FROM joined_member j
  JOIN menu m ON j.product_id = m.product_id
  WHERE row_num = 1
  ORDER BY customer_id ASC;
  



--7.Which item was purchased just before the customer became a member?
WITH joined_member AS (
  SELECT 
    m.customer_id, 
    m.join_date, 
    s.order_date, 
    DENSE_RANK() OVER (PARTITION BY m.customer_id ORDER BY s.ORDER_DATE DESC) as ranked, s.product_id 
    FROM sales s
    JOIN members m ON m.customer_id = s.customer_id AND  s.order_date < m.join_date
)
  
SELECT DISTINCT j.customer_id, m.product_name
  FROM joined_member j
  JOIN menu m ON j.product_id = m.product_id
  WHERE ranked = 1
  ORDER BY customer_id ASC;


--8.What is the total items and amount spent for each member before they became a member?


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


--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
 

SELECT 
  s.customer_id,
  SUM(CASE
  	WHEN m.product_name = 'sushi' THEN price * 20
  	ELSE PRICE * 10
  END) AS points
  FROM sales s
  JOIN menu m on s.product_id = m.product_id
 GROUP BY s.customer_id ;

--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

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
  





