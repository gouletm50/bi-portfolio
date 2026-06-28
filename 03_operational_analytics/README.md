# Operational Analytics – Manufacturing Performance Dashboard

## Overview

This project analyzes production performance in a manufacturing environment, with a focus on understanding operational delays and their potential drivers.

The analysis investigates whether production delays are influenced by supplier quality, product mix, inventory levels, or seasonal effects.

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

A supporting inventory model was created to simulate seasonal fluctuations and reorder thresholds.

---

## Approach

The analysis was conducted using SQL and Power BI and explores operational performance from multiple perspectives:

- Production delay trends over time  
- Supplier-level delay patterns  
- Product-level performance variation  
- Supplier defect rates  
- Monthly inventory levels  
- Relationship between inventory pressure and production delays  

All SQL logic is documented in `business_analysis.sql`.

---

## Key Findings

### 1. Production delays show clear seasonality
Delays do not follow a consistent upward or downward trend over time. Instead, they tend to increase during summer months across both years of data.

---

### 2. Product mix is not a major driver of delays
Delay performance is relatively consistent across products, suggesting that product type is not a key factor in operational variation.

---

### 3. Supplier quality varies significantly
Frontier Supply shows a notably higher defect rate compared to other suppliers, indicating a potential source of operational risk.

---

### 4. Inventory levels remain generally stable
Inventory stays above reorder thresholds throughout the period. While margins tighten during summer months, inventory shortages do not appear to be a primary constraint.

---

### 5. Inventory pressure shows a weak relationship with delays
Periods of lower inventory buffer sometimes coincide with higher delays, but the relationship is not consistent enough to suggest a strong dependency.

---

## Conclusion

The analysis suggests that production delays are primarily driven by seasonal operational patterns rather than structural issues in inventory management or product mix.

Supplier quality differences—particularly the elevated defect rate from Frontier Supply—represent a more meaningful operational risk factor.

Overall, seasonal demand pressure and supplier variability appear more influential on delays than inventory constraints alone.

---

## SQL Analysis

All transformations, calculations, and analytical queries are documented in `business_analysis.sql`.
