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


-- Profit Margin (%)

SELECT 
	Product_type, 
	SKU, 
	(((Revenue_generated) / NULLIF(Number_of_products_sold, 0)) - 
	 ((Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0))) / 
	 ((Revenue_generated) / NULLIF(Number_of_products_sold, 0)) * 100 AS Profit_margin_pct
 FROM supply2
 ORDER BY Profit_margin_pct DESC;

 -- Profit per unit sold 

SELECT 
	Product_type, 
	SKU, 
	(Revenue_generated) / NULLIF(Number_of_products_sold, 0) - 
	(Shipping_costs + Manufacturing_costs + Costs) / NULLIF(Number_of_products_sold, 0) AS Profit_per_unit_sold
FROM Supply2;

-- Revenue per unit sold

SELECT 
	Product_type, 
	SKU, 
	Revenue_generated, 
	Number_of_products_sold,
	Revenue_generated / NULLIF(Number_of_products_sold, 0) AS Revenue_per_unit_sold
FROM supply2;

-- Stock turnover ratio 

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


-- supplier stockout status

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

   -- Total cost per product

SELECT 
	Product_type, 
	SKU,
	(Shipping_costs + Manufacturing_costs + Costs) AS Total_cost_per_product
FROM supply2;


-- Total profit per product

SELECT 
	Product_type, 
	SKU,
    (Revenue_generated) - (Shipping_costs + Manufacturing_costs + Costs) AS Total_profit_per_product
FROM supply2;