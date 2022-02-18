------OVERALL PERFORMANCE BY YEAR in 2009 - 2012 --
SELECT 
  YEAR(order_date) as Years, 
  SUM(sales) as sales, 
  COUNT(order_quantity) as number_of_order 
FROM 
  dbo.dqlab_sales_store 
WHERE 
  order_status = 'Order Finished' 
GROUP BY 
  YEAR(order_date) 
ORDER BY 
  1;

--Overall Performance by Product Sub Category in 2011 until 2012--
SELECT 
  YEAR(order_date) as Years, 
  product_sub_category, 
  SUM(sales) as Sales 
FROM 
  dbo.dqlab_sales_store 
WHERE 
  order_status = 'Order Finished' 
  AND YEAR(order_date)> 2010 
GROUP BY 
  YEAR(order_date), 
  product_sub_category 
ORDER BY 
  Years, 
  Sales DESC;

--Promotion Effectiveness and Efficiency by Years--
SELECT 
  YEAR (order_date) as years, 
  SUM(sales) as sales, 
  SUM(discount_value) as promotion_value, 
  ROUND(SUM(discount_value)/ SUM(sales)* 100,2) as burn_rate_percentage 
FROM 
  dbo.dqlab_sales_store 
WHERE 
  order_status = 'Order Finished' 
GROUP BY 
  YEAR(order_date) 
ORDER BY 
  years ASC;

--Promotion Effectiveness and Efficiency by Product Sub Category--
SELECT 
  YEAR(order_date) as years, 
  product_category, 
  product_sub_category, 
  SUM(sales) as sales, 
  ROUND(SUM(discount_value)/ SUM(sales)* 100, 2) as burn_rate_percentage 
FROM 
  dbo.dqlab_sales_store 
WHERE 
  order_status = 'Order Finished' 
GROUP BY 
  YEAR(order_date), 
  product_sub_category, 
  product_category 
ORDER BY 
  burn_rate_percentage DESC;

---Customers Transactions per Year---
SELECT 
  YEAR (order_date) as years, 
  COUNT(DISTINCT customer) as number_of_customer 
From 
  dbo.dqlab_sales_store 
WHERE 
  order_status = 'Order Finished' 
GROUP BY 
  YEAR(order_date) 
ORDER BY 
  years;

  --Create a New Table for Classification Order Type for anlyze Customer Retention ---
SELECT DISTINCT customer,
sales,
order_date,
MIN(order_date)OVER(PARTITION BY customer) AS first_purchase_date,
CASE 
 WHEN order_date=MIN(order_date)OVER(PARTITION BY customer)THEN 'First order'
 ELSE 'Repeat Order'
 END AS Order_Type
INTO Customer_retention
FROM dbo.dqlab_sales_store
WHERE 
  order_status = 'Order Finished';

----Calculation of the number of new customers and returning customer order
SELECT YEAR(order_date)as years,
COUNT(CASE WHEN Order_Type='Repeat Order'then 1 end) as count_returning_customer
FROM dbo.Customer_retention
GROUP BY YEAR(order_date);

SELECT YEAR(order_date) as years,
COUNT(CASE WHEN Order_Type='First Order'then 1 end) as count_new_customer
FROM dbo.Customer_retention
GROUP BY YEAR(order_date);

---RETANTION RATE BY YEAR--
SELECT YEAR(order_date) as years,
((COUNT(Order_Type)-COUNT(CASE WHEN Order_Type='First Order'then 1 end))/COUNT(CASE WHEN Order_Type='Repeat Order'then 1 end))*100 AS RETANTON_RATE
  FROM dbo.Customer_retention
  GROUP BY YEAR(order_date);

