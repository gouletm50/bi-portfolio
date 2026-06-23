# Operational Analytics 

## Overview

This project analyzes production delays within a manufacturing operation to better understand the factors associated with operational performance.

The analysis explores whether delays are linked to supplier quality, product mix, inventory conditions, or broader seasonal patterns.

---

## Business Question

What factors are associated with production delays in the manufacturing process?

---

## Data

The analysis uses the following tables:

- production_orders
- suppliers
- products
- defects
- inventory_balance

A supporting inventory model was created to simulate seasonal inventory pressure through dynamic reorder thresholds.

---

## Approach

The analysis investigates production delays from multiple perspectives:

1. Delay trends over time  
2. Supplier-level delay patterns  
3. Product-level delay patterns  
4. Supplier defect rates  
5. Inventory position by month  
6. Relationship between inventory pressure and production delays  

Each question is explored through SQL-based analysis and documented in `business_analysis.sql`.

---

## Key Findings

### Production delays are seasonal

Average production delays do not show a clear upward trend over time. Instead, delays tend to increase during summer months across both years of data.

### Products are not a major driver of delays

Average delay levels are relatively similar across products, suggesting that product type alone does not explain operational performance differences.

### Supplier quality varies significantly

Frontier Supply exhibits a substantially higher defect rate than the other suppliers. This suggests supplier quality may contribute to production disruptions and operational risk.

### Inventory remains generally healthy

Inventory levels remain above reorder thresholds throughout the observed period. While inventory gaps narrow during summer months, inventory does not appear to be a primary constraint.

### Inventory pressure may contribute to delays

Months with lower inventory gaps often coincide with higher production delays. However, this relationship is not consistent enough to conclude that inventory is the main driver of delays.

---

## Conclusion

The analysis suggests that production delays are primarily seasonal in nature. Supplier quality differences, particularly the elevated defect rate associated with Frontier Supply, appear to be a more significant operational concern than product mix or inventory shortages.

Overall, the findings indicate that seasonal operational pressure and supplier quality are more closely associated with production delays than inventory constraints alone.

---

## SQL

All analysis queries and observations are documented in `business_analysis.sql`.
