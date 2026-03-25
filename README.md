# SQL Practice – Product, Price and Barcode Queries

This repository contains practical SQL queries I wrote to work with product (items), price (prices), and barcode (barcodes) data in SQL Server.

## What I Learned

Through these queries, I practiced the following SQL topics:

- Using `JOIN` and `LEFT JOIN` to combine tables
- Applying filters with `WHERE`
- Counting data using `COUNT` and `GROUP BY`
- Using `EXISTS` and `NOT EXISTS`
- Working with date functions like `DATEADD`, `GETDATE`, and `EOMONTH`
- Using window functions (`COUNT() OVER()`)
- Analyzing active and inactive product statuses
- Checking product price start and end dates
- Retrieving barcode, price, and product information together
- Calculating total sales per invoice and per customer using `SUM`.
- Finding top-selling products and highest revenue-generating customers.
- Identifying unsold products and customers with no invoices.
- Using aggregate functions like `MAX` to find last purchase dates.
- Counting different products purchased per customer.

## Tables Used

- `CRD_CLIENTS` – client information 
- `CRD_ITEMS` – product information  
- `CRD_PRICES` – product prices  
- `CRD_ITEMBARCODES` – product barcodes
- `CRD_ITEMGROUPS` – product groups / categories  
- `OPR_INVOICE` – invoices / sales transactions  
- `OPR_STLINE` – invoice line items
  
## Practical Tasks

These queries solve the following problems:

- Display product barcode, price, and status
- Count prices for specific products
- Find active and inactive prices
- Filter prices based on end date
- Retrieve barcode and price information for specific products
- Display invoice, customer, product, barcode, quantity, price, and total amount together.
- Calculate total purchase amounts per customer and last purchase dates.
- Find top 5 best-selling products and top revenue-generating customers.
- Identify products that were never sold and customers who never made a purchase.
- Count the number of different products purchased by each customer.
  
## 🛠 Technologies

- SQL (T-SQL compatible)

---

👩‍💻 Author: Zahra
