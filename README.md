# SQL Practice – ERP Database Queries

![GitHub repo size](https://img.shields.io/github/repo-size/zahraafg/POSFAPCENTER)
![GitHub last commit](https://img.shields.io/github/last-commit/zahraafg/POSFAPCENTER)
![GitHub language](https://img.shields.io/github/languages/top/zahraafg/POSFAPCENTER)

This repository contains practical SQL queries written using a custom ERP-style database schema (POSFAPCENTER).  
The goal of this project is to improve SQL skills by working with real-world relational data.

---

## Project Overview

This project focuses on writing SQL queries to analyze data related to:

- Products
- Prices
- Barcodes
- Customers
- Invoices
- Sales transactions
- Return transactions
- Payment details
- POS terminals
- Bank and currency information

---

## What I Practiced

Through these queries, I improved my understanding of:

- `JOIN` and `LEFT JOIN`
- Filtering data using `WHERE` and `HAVING`
- Aggregate functions (`SUM`, `COUNT`, `MAX`)
- Grouping data using `GROUP BY`
- Window functions (`ROW_NUMBER`)
- Working with invoices and transactional data
- Calculating total sales and analyzing customers
- Identifying top and low-performing records
- Extracting last transaction dates

---

## Tables Used

- `CRD_CLIENTS` – customer information  
- `CRD_ITEMS` – product information  
- `CRD_PRICES` – product pricing  
- `CRD_ITEMBARCODES` – product barcodes  
- `CRD_ITEMGROUPS` – product categories
- `CRD_BANKCURRENCY` – bank currency information  
- `CRD_BANKTERMINAL` – POS terminals  
- `OPR_INVOICE` – invoices  
- `OPR_STLINE` – invoice line items  
- `OPR_ACCOUNTS` – account mappings  

---

## Analysis
- Monthly Top Product
- Monthly Sales Trend (LAG / LEAD)

---

## Purpose
This project is created for:

- Practicing real-world SQL scenarios
- Improving backend/data querying skills
- Preparing for junior SQL / backend interviews
- Building a strong GitHub portfolio

---

## 📁 Repository Structure
Sorğular/ – contains all SQL query files
Each file includes practical query examples solving real problems

---

## Sample Queries

Below are some example queries from this project:

👉 For all queries, see the full list here:  
[View full SQL queries on GitHub](https://github.com/zahraafg/POSFAPCENTER/tree/main/Sor%C4%9Fular)

---

---

## ERP SQL Task: Invoice, Return and Payment Details Extraction

```sql
SELECT 
	ITM_CODE,
	ITM_NAME,
	INV_FICHENO,
	INV_RTNFICHENO,
	INV_RTNPURPOSE, 
	INV_RTNCLNAME, 
	INV_TRCODE, 
	INV_DATETIME,
	STL_TRCODE, 
	BNC_NAME,
	ACO_PAYTYPE,
	case 
	when STL_TRCODE = 1 then 'satilib'
	when STL_TRCODE = 2 then 'qaytarib'
	end as status
FROM CRD_ITEMS
LEFT JOIN OPR_STLINE
ON STL_ITMCODE = ITM_CODE
LEFT JOIN OPR_INVOICE
ON INV_FICHENO = STL_FICHENO
LEFT JOIN OPR_ACCOUNTS
ON ACO_INVFICHENO = INV_FICHENO
LEFT JOIN CRD_BANKCURRENCY
ON BNC_ID = ACO_BNCID
WHERE INV_FICHENO = '101001260209165125'
OR INV_RTNFICHENO = '101001260209165125';
```
---

## Last Sale Date per Product

```sql
WITH CTE AS(
SELECT 
	ITM_CODE,
	ITM_NAME,
	INV_DATETIME,
	ROW_NUMBER() OVER(
	PARTITION BY ITM_NAME
	ORDER BY INV_DATETIME DESC
	) AS RN
FROM CRD_ITEMS
LEFT JOIN OPR_STLINE
ON STL_ITMCODE = ITM_CODE 
LEFT JOIN OPR_INVOICE
ON INV_FICHENO = STL_FICHENO
-- WHERE ITM_CODE = '101216'
)
SELECT *
FROM CTE
-- WHERE RN = 1;

--OR
SELECT 
	ITM_CODE,
	ITM_NAME,
	MAX(INV_DATETIME) AS LAST_DAY
FROM CRD_ITEMS
LEFT JOIN OPR_STLINE
ON STL_ITMCODE = ITM_CODE
LEFT JOIN OPR_INVOICE
ON INV_FICHENO = STL_FICHENO
-- WHERE ITM_NAME = 'LAYS CIPS 140 GR KABABLI'
GROUP BY 
	ITM_CODE,
	ITM_NAME
ORDER BY LAST_DAY DESC;
```
---

## 🛠 Technologies
SQL (T-SQL compatible)
SQL Server

---

## 🔗 Full Project
👉 https://github.com/zahraafg/POSFAPCENTER

---

👩‍💻 Author: Zahra
