# Sales Performance – Sales Analytics Dashboard

## Overview

This project analyzes sales performance in a manufacturing environment, with a focus on understanding revenue trends and the factors contributing to overall sales performance.

The analysis examines revenue across territories, products, customers, and sales representatives, with a deeper investigation into a significant year-over-year revenue decline in April 2025.

---

## Business Questions

The analysis addresses several business questions:

* How is overall revenue changing over time?
* Where is revenue being generated geographically?
* Which products and customers contribute most to revenue?
* How is the sales organization performing?
* What factors explain the April 2025 revenue decline compared with April 2024?

---

## Data

The analysis uses a sales data warehouse containing:

* `fact_sales`
* `dim_customers`
* `dim_products`
* `dim_sales_reps`
* `dim_territories`
* `product_price_history`
* `product_cost_history`
* `sales_orders`
* `sales_order_lines`
* `sales_order_activity`

The sales fact table contains transaction-level sales information, including product, customer, sales representative, territory, quantity, pricing, discounts, and costs.

---

## Approach

The analysis was conducted using SQL and Power BI and explores sales performance from multiple perspectives:

* Revenue trends over time
* Revenue by territory
* Revenue contribution by product
* Customer revenue concentration
* Sales representative performance
* Product performance across the business
* Year-over-year revenue variance
* Territory-level drivers of the revenue decline
* Customer-level changes in Pump A200 purchases

All SQL transformations and analytical logic are documented in the project SQL files.

---

## Dashboard

The Power BI report is organized into four analytical views:

### 1. Executive Overview

Provides a high-level view of sales performance, including:

* Total Revenue
* Total Gross Profit
* Gross Margin %
* Total Quantity Sold
* Revenue trends over time
* Revenue distribution across territories

### 2. Sales Analysis

Examines the main drivers of sales performance across:

* Territories
* Product categories
* Customers
* Sales representatives

### 3. Product Performance Analysis

Examines revenue and sales performance at the individual product level to identify the products contributing most to overall sales.

### 4. Revenue Variance Analysis

Investigates why April 2025 revenue was lower than April 2024, moving from the overall revenue variance to product, territory, and customer-level analysis.

---

## Key Findings

### 1. Revenue performance varies significantly across territories

Revenue is concentrated in several key territories, with differences in product mix contributing to regional performance.

---

### 2. A small number of products contribute significantly to revenue

Product-level analysis shows that revenue is concentrated among several key products, making product mix an important consideration when evaluating overall sales performance.

---

### 3. Revenue is concentrated among key customers

The highest-revenue customers account for a significant share of total sales, highlighting the importance of key accounts to overall commercial performance.

---

### 4. April 2025 revenue declined significantly

Total revenue decreased from **$746,673.75** in April 2024 to **$573,810.38** in April 2025, representing a decline of approximately **23%**.

---

### 5. Pump A200 was the primary driver of the April decline

Pump A200 revenue decreased from approximately **$267,592** in April 2024 to **$77,306** in April 2025.

The decline in Pump A200 revenue was greater than the company's total revenue decline, meaning that growth in other products partially offset the loss.

---

### 6. The Pump A200 decline occurred across multiple territories

The largest territory-level declines occurred in:

* **Greater Toronto Area**
* **Eastern Ontario**
* **Montreal**

Atlantic Canada was the only territory showing growth in Pump A200 revenue and partially offset the losses elsewhere.

---

### 7. Several customers had substantially lower April Pump A200 purchases

Customer-level analysis identified several existing customers whose April Pump A200 purchases were significantly lower in 2025 compared with 2024.

However, further analysis of annual purchasing patterns showed that some customers continued purchasing Pump A200 outside of April 2025.

This suggests that the April decline may be influenced by **purchase timing or order timing**, rather than representing permanent customer loss.

---

## Conclusion

The analysis shows that overall sales performance is influenced by differences in territory, product, customer, and sales representative contribution.

The April 2025 revenue decline was primarily driven by a substantial decrease in Pump A200 revenue. The decline was broad-based across several territories and was associated with lower April purchasing activity from several customers.

However, annual purchasing patterns indicate that some affected customers continued purchasing Pump A200 outside of April, highlighting the importance of considering purchasing timing before concluding that customers have permanently stopped buying a product.

---

## SQL Analysis

All transformations, calculations, and analytical queries used in the project are documented in the SQL files within the repository.
