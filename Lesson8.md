# Assessment 3: Homework handbook lesson 8
***

###  Lesson8
#### 1. Write a query based on the data in the Orders table that ranks the years according to the profits from all the orders during each year.
#### Instructions:
---
#### a. Decide which tables are involved in solving the query. Use the ERD for assistance. Hint: 3 tables.
**USE 3 TABLES : Sales.SalesorderHeader, Sales.SalesOrderDetail, Production.Product**  

Reason : All order information needed.  
- 'SalesOrderID' (TABLE: SalesorderHeader or SalesOrderDetail)
- 'OrderQty' (TABLE: SalesOrderDetail)
- 'OrderDate' (TABLE: SalesOrderDetail)
- 'Profit' (TABLE: Product)  

---
![](2025-03-14-18-13-18.png)
![relationIMAGE](https://drive.google.com/file/d/1qjD-B1wu4bjvo7t23PuNdtjuAdGpzep4/view?usp=sharing "relationIMAGE")
---
  

b. How is profit calculated?  

Profit = the difference between the price list price of the item and its cost.  
i.e, ListPrice - StandardCost (TABLE: Production.Product)
  

However, for the order list, each order is described based on Unitprice.
In addition, there is a discount based on Unitprice. (very slight).
Therefore, in order to strictly determine the profit, the red box in the figure should also be used.  

```SQL
Profit = ((LineTotal / OrderQty) - StandardCost) * OrderQty
```

---

c. Is the profit calculated per item, or for all the items in the order record? (Pay attention to the OrderQty column.)  

The profit calculated per item. That's because profit rates are different from each product.


---
d. Following is a preview of the query results:  

* Q1 Answer code

```sql
SELECT YEAR(OrderDate) AS 'OrderDate',
    SUM(((LineTotal/OrderQty) - StandardCost) * sod.OrderQty) AS 'TotalProfit',
    RANK() OVER (ORDER BY SUM(((LineTotal/OrderQty) - StandardCost)  * sod.OrderQty) ASC) AS 'YearRank'
FROM AdventureWorks2016.Sales.SalesOrderDetail sod
    JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
    JOIN AdventureWorks2016.Production.Product pp
    ON sod.ProductID = pp.ProductID
GROUP BY YEAR(OrderDate);
```

#### 2. Continuing from the previous question: Are the ranking and comparison done annually analytically correct?
(To answer this question, examine the order dates and data.)
* Q2 Answer  

Some products come with limited time discounts. The following is a list of the actual limited time discounts used by linking the Sales.SalesOrderDetail Table and Sales.SpecialOffer tables.

```SQL
SELECT sod.SpecialOfferID,
    MAX(sso.Category) AS 'TargetGroup',
    MAX(sod.UnitPriceDiscount) AS 'MaxDiscount', 
    MAX(sso.StartDate) AS 'DiscountDate'
FROM [AdventureWorks2016].[Sales].[SalesOrderDetail] sod
    JOIN [AdventureWorks2016].[Sales].[SpecialOffer] sso
    ON sod.SpecialOfferID = sso.SpecialOfferID
GROUP BY sod.SpecialOfferID
ORDER BY sod.SpecialOfferID
```
  
Comparing annual profits without taking this irregularity discount into account is not strictly accurate, even if the difference is small.