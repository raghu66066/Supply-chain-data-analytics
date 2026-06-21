-- Data Cleaning & EDA

SELECT *
FROM supply;

-- Create a duplicate table

SELECT *
INTO supply2
FROM supply;

SELECT *
FROM supply2;

-- #Data Cleaning Checks 

SELECT COUNT(*), 
COUNT(DISTINCT SKU), 
AVG(Revenue_generated), 
MIN(Stock_levels), 
MAX(Lead_times)
FROM supply2;

-- #Exploratory Data Analysis (EDA)

-- Total revenue by Location

SELECT 
	Location, 
	SUM(Revenue_generated) AS Total_revenue_location
FROM supply2
GROUP BY Location
ORDER BY Total_revenue_location DESC;


-- Total revenue by Product

SELECT 
	Product_type, 
	SUM(Revenue_generated) AS Total_revenue_Product
FROM supply2
GROUP BY Product_type
ORDER BY Total_revenue_Product DESC;


-- Average Revenue by Product

SELECT DISTINCT 
	Product_type, 
	AVG(Revenue_generated) AS Average_revenue_product
FROM supply2
GROUP BY Product_type
ORDER BY Average_revenue_product DESC;

-- Which product generates most revenue in a Location

SELECT 
	Location, 
	Product_type, 
	SUM(Revenue_generated) AS Total_revenue
FROM supply2
GROUP BY Location, Product_type
ORDER BY Total_revenue DESC;

-- Comparing Revenues Across Locations for a Product

SELECT 
	Location, 
	Product_type, 
	SUM(Revenue_generated) AS Location_revenue
FROM supply2
WHERE Product_type = 'skincare'
GROUP BY Location, Product_type
ORDER BY Location_revenue DESC;

-- Analyzing Product-Wise Revenue in a Location

SELECT 
	Product_type, 
	Location, 
	SUM(Revenue_generated) AS Product_revenue
FROM supply2
WHERE Location = 'Mumbai'
GROUP BY Product_type, Location
ORDER BY Product_revenue DESC;

-- Price Analysis

SELECT 
	Product_type,
	AVG(Price) avg_price, 
	MIN(Price) min_price, 
	MAX(Price) max_price, 
	STDEV(Price) stddev_price
FROM supply2
GROUP BY Product_type;

/* Feature Engineering*/

-- Revenue per unit sold

SELECT 
	Product_type, 
	SKU, 
	Revenue_generated, 
	Number_of_products_sold,
	Revenue_generated / NULLIF(Number_of_products_sold, 0) AS Revenue_per_unit_sold
FROM supply2;

-- Cost per unit sold

SELECT 
	Product_type, 
	SKU,
	(Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0) AS Cost_per_unit_sold
FROM supply2
ORDER BY Cost_per_unit_sold DESC;



-- Profit per unit sold 

SELECT 
	Product_type, 
	SKU, 
	(Revenue_generated) / NULLIF(Number_of_products_sold, 0) - 
	(Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0) AS Profit_per_unit_sold
FROM Supply2;

-- Profit Margin (%)

SELECT 
	Product_type, 
	SKU, 
	(((Revenue_generated) / NULLIF(Number_of_products_sold, 0)) - 
	 ((Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0))) / 
	 ((Revenue_generated) / NULLIF(Number_of_products_sold, 0)) * 100 AS Profit_margin_pct
 FROM supply2
 ORDER BY Profit_margin_pct DESC;

 -- all details

 with cost_analysis AS (
 SELECT 
	Product_type, 
	SKU, 
	Revenue_generated, 
	Number_of_products_sold,
	(Shipping_costs + Manufacturing_costs + Costs) total_costs,
	Revenue_generated / NULLIF(Number_of_products_sold, 0) AS Revenue_per_unit_sold,
	(Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0) AS Cost_per_unit_sold,
	(Revenue_generated) / NULLIF(Number_of_products_sold, 0) - 
	(Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0) AS Profit_per_unit_sold
 FROM supply2
 )
 select Product_type, 
	SKU, 
	Revenue_generated, 
	Number_of_products_sold,
	total_costs,
	Revenue_per_unit_sold,
	Cost_per_unit_sold,
	Profit_per_unit_sold,
	round(Profit_per_unit_sold/Revenue_per_unit_sold*100, 2) as Profit_margin_pct
 from cost_analysis
 ORDER BY Profit_margin_pct DESC;

 -- Total cost per product

SELECT 
	Product_type, 
	SKU,
	(Shipping_costs + Manufacturing_costs + Costs) AS Total_cost_per_product
FROM supply2;

-- Total revenue per product

SELECT 
    Product_type, 
	SKU,
	Revenue_generated
FROM supply2
ORDER BY Revenue_generated DESC;

-- Total profit per product

SELECT 
	Product_type, 
	SKU,
    (Revenue_generated) - (Shipping_costs + Manufacturing_costs + Costs) AS Total_profit_per_product
FROM supply2;


-- Cost breakdown ratios, this is calculated against the total_cost

SELECT 
	Product_type, 
	SKU,
	(Shipping_costs) / (Shipping_costs + Manufacturing_costs + Costs) AS Shipping_costs_ratio,
	(Manufacturing_costs) / (Shipping_costs + Manufacturing_costs + Costs) AS Manufacturing_costs_ratio,
	(Costs) / (Shipping_costs + Manufacturing_costs + Costs) AS Other_costs_ratio
FROM supply2;

-- overall stockout rate

SELECT
    COUNT(CASE WHEN Stock_levels = 0 THEN 1 END) * 1.0 / COUNT(*) AS Overall_stockout_rate
FROM supply2;

-- Stock efficiency

SELECT 
	Product_type, 
	SKU,
	Number_of_products_sold, 
	Stock_levels,
	Number_of_products_sold / NULLIF(Stock_levels, 0) AS Stock_turnover_ratio,
CASE
	WHEN Number_of_products_sold / NULLIF(Stock_levels, 0)  < 0.5 THEN 'Overstocked'
    WHEN Number_of_products_sold / NULLIF(Stock_levels, 0) <= 2 THEN 'Balanced'
    WHEN Number_of_products_sold / NULLIF(Stock_levels, 0) <= 10 THEN 'Fast-moving'
    WHEN Number_of_products_sold / NULLIF(Stock_levels, 0) > 10 THEN 'Undersocked'
END AS 'Stock status'
FROM supply2
ORDER BY Stock_turnover_ratio DESC;

SELECT 
	Product_type, 
	SKU,
	Number_of_products_sold, 
	Stock_levels,
 CASE 
    WHEN Stock_levels = 0 AND Number_of_products_sold > 0 THEN 999
    ELSE ROUND(Number_of_products_sold / NULLIF(Stock_levels, 0), 2)
  END AS Stock_turnover_ratio,

  CASE 
    WHEN Stock_levels = 0 AND Number_of_products_sold > 0 THEN 'Critical - Likely out of stock'
    WHEN (Number_of_products_sold / NULLIF(Stock_levels, 0)) < 0.5 THEN 'Overstocked'
    WHEN (Number_of_products_sold / NULLIF(Stock_levels, 0)) <= 2 THEN 'Balanced'
    WHEN (Number_of_products_sold / NULLIF(Stock_levels, 0)) <= 10 THEN 'Fast-moving'
    WHEN (Number_of_products_sold / NULLIF(Stock_levels, 0)) > 10 THEN 'Understocked'
    ELSE 'Critical - Likely out of stock soon'
  END AS Stock_status
FROM supply2
ORDER BY Stock_turnover_ratio DESC;


-- Understocked/critical-likely out of stock (soon) by supplier

SELECT 
  Supplier_name,

  CASE 
    WHEN Stock_levels = 0 AND Number_of_products_sold > 0 THEN 'Understocked'
    WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) > 10 THEN 'Understocked'
    WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 0.5 THEN 'Overstocked'
    WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 2 THEN 'Balanced'
    WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 10 THEN 'Fast-moving'
    ELSE 'Understocked'
  END AS Stock_status1
FROM supply2;




WITH supplier_stock_status AS (

SELECT 
    Supplier_name,
    Lead_time,
    CASE 
		    WHEN Stock_levels = 0 AND Number_of_products_sold > 0 THEN 'Understocked'
            WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) > 10 THEN 'Understocked'
            WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 0.5 THEN 'Overstocked'
            WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 2 THEN 'Balanced'
            WHEN (Number_of_products_sold * 1.0 / NULLIF(Stock_levels, 0)) <= 10 THEN 'Fast-moving'
            ELSE 'Understocked'
    END AS stock_status
  FROM supply2
  )
  SELECT 
	  Supplier_name,
	  COUNT(*) AS Total_SKU,
	  COUNT(CASE WHEN stock_status = 'Understocked' THEN 1 END) AS Understocked_SKU,
	  ROUND(CAST(COUNT(CASE WHEN stock_status = 'Understocked' THEN 1 END) as float)/ COUNT(*) * 100, 2) AS Percentage_understocked,
	  ROUND(AVG(Lead_time), 2) AS Avg_lead_time
  FROM supplier_stock_status
  group by Supplier_name
  order by Avg_lead_time DESC;

-- Lead Time Impact
-- 1. Supplier speed category per product



  SELECT 
  Product_type,
  SKU,
  Lead_time,
  Supplier_name,
  CASE
    WHEN Lead_time BETWEEN 1 AND 3 THEN 'Fast'
    WHEN Lead_time BETWEEN 4 AND 7 THEN 'Moderate'
    WHEN Lead_time BETWEEN 8 AND 14 THEN 'Slow'
    WHEN Lead_time >= 15 THEN 'Very Slow'
    ELSE 'Unknown'
  END AS Supplier_speed_category
FROM Supply2;

-- 2. Number of products in each category



SELECT
    Supplier_speed_category,
    COUNT(*) AS Number_of_products
FROM (SELECT
        CASE
            WHEN Lead_time BETWEEN 1 AND 3 THEN 'Fast'
            WHEN Lead_time BETWEEN 4 AND 7 THEN 'Moderate'
            WHEN Lead_time BETWEEN 8 AND 14 THEN 'Slow'
            WHEN Lead_time >= 15 THEN 'Very Slow'
            ELSE 'Unknown'
        END AS Supplier_speed_category
    FROM supply2)t
GROUP BY Supplier_speed_category
ORDER BY Number_of_products DESC;

-- 3. Product types that suffer the most delays


SELECT 
    Product_type,
    COUNT(*) AS Number_of_products,
    AVG(Lead_time) AS Avg_lead_time
FROM supply2
GROUP BY Product_type
ORDER BY Avg_lead_time DESC;

-- 4. Products from very slow suppliers


SELECT 
    Product_type,
    SKU,
    Supplier_name,
    Lead_time,
    'Very Slow' AS Supplier_speed_category
FROM Supply2
WHERE Lead_time >= 15
ORDER BY Lead_time DESC;


-- 5. Supplier speed category per suppliers



SELECT 
  Supplier_name,
  COUNT(*) AS Orders_from_Supplier,
  AVG(Lead_time) AS Avg_lead_time,
  CASE 
    WHEN AVG(Lead_time) <= 10 THEN 'Fast'
    ELSE 'Slow'
  END AS Supplier_Speed
FROM supply2
GROUP BY Supplier_name
ORDER BY Avg_lead_time ASC;


-- Unit price deviation from mean



SELECT 
  Product_type,
  SKU,
  Supplier_name,
  Price AS Unit_Price,
  ROUND(AVG(Price) OVER (PARTITION BY Product_type), 2) AS Avg_price_per_product_type, 
  ROUND(Price - AVG(Price) OVER (PARTITION BY Product_type), 2) AS Price_deviation
FROM supply2;


-- Average price per product

SELECT 
  Product_type,
  AVG(Price) AS Avg_price_per_product
FROM supply2
GROUP BY Product_type;

-- Price deviation classification



SELECT 
  Product_type,
  SKU,
  Price,
  AVG(Price) OVER (PARTITION BY Product_type) avg_price_by_prod,
  ROUND(Price - AVG(Price) OVER (PARTITION BY Product_type), 2) AS Price_Deviation,
  CASE 
    WHEN (Price - AVG(Price) OVER (PARTITION BY Product_type)) <= -5 THEN 'Underpriced'
    WHEN (Price - AVG(Price) OVER (PARTITION BY Product_type)) BETWEEN -5 AND 5 THEN 'Standard'
    WHEN (Price - AVG(Price) OVER (PARTITION BY Product_type)) > 5 THEN 'Overpriced'
    ELSE 'Unknown'
  END AS Pricing_Category
FROM supply2;



SELECT 
  Product_type,
  SKU,
  Price,
  AVG(Price) OVER (PARTITION BY Product_type) avg_price_by_prod,
  ROUND(Price - AVG(Price) OVER (PARTITION BY Product_type), 2) AS Price_Deviation,
  ROUND(STDEV(Price) OVER (PARTITION BY Product_type), 2) AS Std_Dev,
  CASE 
    WHEN Price < AVG(Price) OVER (PARTITION BY Product_type) - STDEV(Price) OVER (PARTITION BY Product_type) THEN 'Underpriced'
    WHEN Price > AVG(Price) OVER (PARTITION BY Product_type) + STDEV(Price) OVER (PARTITION BY Product_type) THEN 'Overpriced'
    ELSE 'Standard'
  END AS Pricing_Category
FROM supply2;