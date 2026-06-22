# 📦 Supply-Chain-Performance-Analysis
![360_F_90554856_mABMl9eC0sSoZSd8vbE4gWA0ufv2VMr7](https://github.com/raghu66066/Supply-chain-data-analytics/blob/fc917e7fa55cc559f183c43d9f3123c03197567c/Powerbi_image/supply-chain-management.webp)

The objective is to evaluate sales &amp; profitability, inventory alignment, supplier performance, shipping efficiency, and quality control — and translate findings into clear, actionable recommendations for decision-makers.

---

## 📌 Executive Summary

1. **Sales & Profitability** → Skincare drives revenue & profit; Cosmetics requires margin optimization.  
2. **Inventory Management** → Misaligned stock levels; understock & long lead time increase stockout risk.  
3. **Supplier Performance** → Long lead time directly linked to understock issues.  
4. **Shipping & Logistics** → Trade-offs between cost and speed across carriers/routes.  
5. **Quality Control** → Supplier 5 and Routes A & B drive most defects.  

---

## 🚀 Recommendations

- **Revenue & Profitability:** Prioritize Skincare; revisit Cosmetics strategy.  
- **Inventory Management:** Implement demand-driven replenishment; set reorder points.  
- **Supplier Performance:** Diversify away from Supplier 3 & 5; negotiate SLAs.  
- **Shipping & Logistics:** Favor Carrier B/Route A; investigate inefficiencies in Route B & Chennai.  
- **Quality Control:** Audit Supplier 5; tighten inspections on Haircare & key logistics routes.  

---

## 📌 Project Overview
This project analyzes **supply chain performance** using **SQL** for querying and aggregation, and **Power BI** for visualization and storytelling.  

The goal is to evaluate:
- Sales & profitability  
- Inventory alignment  
- Supplier performance  
- Shipping efficiency  
- Quality control  

and provide clear, actionable recommendations for decision-makers.  

---

## 📂 Dataset
- **Source:** Provided for competition/practice by Onyx Data  
- **Size:** ~100 rows  
- **Main Features:**  
  - Product details (type, SKU, price, stock levels, defect rates)  
  - Supplier information (lead times, performance)  
  - Shipping carriers, routes, and costs  
  - Sales & profitability metrics  
  - Location and customer data  

---

## 🎯 Business Questions

1. **Sales & Profitability**
- Which product types generate the most revenue?
- Which SKUs are bestsellers by quantity and revenue?
  
2. **Inventory Management**
- Are stock levels aligned with sales?
- Which products are at risk due to low stock and long lead times?

3. **Supplier Performance**
- Which suppliers have the longest lead times?
- What is the relationship between supplier lead time and stockouts?
  
4. **Shipping & Logistics**
- Which shipping carriers are cost-efficient and fast?
- Are there specific routes or locations that increase cost or time?
  
9. **Quality Control**
- What are the defect rates per product or production line?
- Which suppliers or routes lead to higher defect rates?

---

## 🔍 Data Preparation & EDA

- Minimal cleaning required (validated nulls, duplicates, and data types).  
- The exploratory data analysis (EDA) focused on uncovering patterns, trends, and bottlenecks in supply chain performance.  

**Key Findings:**

- Skincare dominates revenue & profit.  
- Cosmetics has highest average revenue per SKU but lower margins.  
- Haircare products show higher defect rates.  
- Mumbai & Kolkata perform best in sales; Delhi lags behind.  
- Supplier 3 & 5 drive delays and defects respectively.
- Route B is slowest and Route C is most costly.  

---

## 📊 Insights by Business Area

### 💰 Sales & Profitability
<img width="1294" height="724" alt="Sales   Profitability" src="https://github.com/raghu66066/Supply-chain-data-analytics/blob/59f510a7300d4721ca8d9e5d07f2763c955f5054/Powerbi_image/sales_profitability.png" />

- Revenue: Skincare leads with $242K, followed by Haircare ($174K) and Cosmetics ($162K).
- Profit Margins: Skincare (40%), Haircare (34%), Cosmetics (26%).
- Bestsellers:
  - By quantity → SKU10, SKU94, SKU9.
  - By revenue → SKU51, SKU38, SKU31.
    
➡️ Implication: Skincare drives both revenue and profit. Cosmetics requires pricing, cost, or marketing review.
  

### 📦 Inventory Management
<img width="1273" height="716" alt="Inventory Management" src="https://github.com/raghu66066/Supply-chain-data-analytics/blob/585d7689c6a0c5afc4918d0435874059bf254ea2/Powerbi_image/inventory%20management.png" />

- Only 12% of products have balanced stock levels.
- 46% are fast-moving, 39% understocked, 2% Overstocked.
  
➡️ Implication: Misaligned stock levels increase risk of stockouts and excess holding costs.


### 🤝 Supplier Performance
<img width="1274" height="715" alt="Supplier Performance" src="https://github.com/raghu66066/Supply-chain-data-analytics/blob/59f510a7300d4721ca8d9e5d07f2763c955f5054/Powerbi_image/supplier%20performance.png" />

- Longest Lead Time: Supplier 3 (20 days).
- Correlation: Longer lead times link to higher understock rates.
  - Supplier 3 → 53% understock.
  - Supplier 2 → 54% understock.
  - Supplier 4 → shorter lead time (15 days) with lowest understock rate (27.8%).
    
➡️ Implication: Suppliers with high lead times drive stockouts.


### 🚚 Shipping & Logistics
<img width="1285" height="724" alt="Shipping   Logistics" src="https://github.com/raghu66066/Supply-chain-data-analytics/blob/59f510a7300d4721ca8d9e5d07f2763c955f5054/Powerbi_image/shipping_logistics.png" />

- Carriers: Carrier A is fastest; Carrier B is most cost-efficient.
- Routes: Route A is balanced; Route B is slowest while Route C most costly.
- Locations:
  - Mumbai → fastest (14 days) but most expensive ($6.25).
  - Chennai → cheapest ($4.69) but longest delays (17 days).
    
➡️ Implication: Trade-offs exist between cost and speed; optimization is needed by carrier and route.
 

### ✅ Quality Control
<img width="1278" height="718" alt="Quality Control" src="https://github.com/raghu66066/Supply-chain-data-analytics/blob/59f510a7300d4721ca8d9e5d07f2763c955f5054/Powerbi_image/quality%20control.png" />

- Defect Rates by Product: Haircare (2.48) > Skincare (2.33) > Cosmetics (1.92).
- Defect Rates by Supplier:
  - Highest → Supplier 5 (2.67).
  - Lowest → Supplier 1 (1.80).
- Defect Rates by Route: Route A (2.34) and Route B (2.32) > Route C (2.05).
  
➡️ Implication: Supplier 5 and certain logistics channels (Routes A & B) drive quality issues.
 
---

## 🛠 Tools & Technologies
- **SQL** → Data extraction, querying, and aggregation.  
- **Power BI** → Dashboards, visuals, and storytelling.  

---

## 📷 Project Deliverables
- 📊 [Power BI Dashboard](https://github.com/raghu66066/Supply-chain-data-analytics/blob/main/SCM%20dashboard.pbix)
- 📜 [SQL Queries](https://github.com/raghu66066/Supply-chain-data-analytics/blob/main/SQL_SCM.sql) 
 
---


## 👤 Author
**Raghu G**  
📧raghu66066@gmail.com 
