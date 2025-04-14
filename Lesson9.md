# Assessment 3: Homework handbook lesson 9

***

###  Lesson 9
#### 1. As an analyst working for AdventureWorks, you are required to check the order data for regular customers only, during 2013.
The company defines a regular customer as a customer who already made a purchase from the store in previous years (i.e., bought in 2012 or 2011).
For each order in 2013, display the order number, the SubTotal and the difference between the SubTotal of that order and the average for all the orders in 2013, based on the sales.SalesOrderHeader table,.
Note: Display the data for regular customers only.

* Q1 Answer code

```SQL
SELECT SalesOrderID, Subtotal,
    Subtotal -
(SELECT AVG(SubTotal)
    FROM AdventureWorks2016.Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2013) 
AS 'DistFromAvg'
FROM AdventureWorks2016.Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
    AND CustomerID IN (
    SELECT CustomerID
    FROM AdventureWorks2016.Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) BETWEEN 2011 AND 2012
    GROUP BY CustomerID
);
```

---

#### 2. Now calculate the same data for all the years and all the customers, similarly to the previous question.
For each order in the Sales.SalesOrderHeader table, display the order number, the SubTotal and the difference between the SubTotal of that order and the average for all the orders.
* Q2 Answer  
```sql
SELECT SalesOrderID,
    SubTotal - AVG(Subtotal) OVER () AS 'DistFromAvg'
FROM AdventureWorks2016.Sales.SalesOrderHeader
```

---

#### 3.Continuing on from the previous question and based on the query you wrote, display the number of orders that are equal to and above the average, and the number of orders below the average.

Before you begin writing the query, think how you would solve it manually (i.e., if you got an order table with 10 rows).    

---
![](2025-03-15-13-30-55.png)
![Handwritten Illustrations](https://drive.google.com/file/d/1xr293z39Xraqgmj5RAiB4AMX8TvBPehz/view?usp=sharing "Handwritten Illustrations")
---
---
Once you have found a way to solve this manually, you can convert it into an SQL query

*When I used the window function, I got an error with the CASE syntax, so I used a regular subquery.*

*progress on the way*
```SQL
SELECT SalesOrderID, Subtotal,
    (SELECT AVG(SubTotal)
    FROM AdventureWorks2016.Sales.SalesOrderHeader) AS 'TotalSalesAVG',
    CASE WHEN SubTotal >= (SELECT AVG(SubTotal)
    FROM AdventureWorks2016.Sales.SalesOrderHeader) THEN 'Above'
ELSE 'Low' END AS 'HighLow'
FROM AdventureWorks2016.Sales.SalesOrderHeader
```
----



*I tried to aggregate the above query but could not resolve the error.*  
 1. Alias unavailable  
 2. Duplicate Aggregate Function  

*Therefore, my answer is not smart : I just connected 2 queries to match the answer.*
* Q3 Answer  
```sql
SELECT 'Above Then AVG' AS 'TextDiffFromAVG', COUNT(*) AS 'CountNo'
FROM  AdventureWorks2016.Sales.SalesOrderHeader
WHERE SubTotal >= (SELECT AVG(SubTotal)
        FROM AdventureWorks2016.Sales.SalesOrderHeader)
UNION
SELECT 'Lower Then AVG', COUNT(*)
FROM  AdventureWorks2016.Sales.SalesOrderHeader
WHERE SubTotal < (SELECT AVG(SubTotal)
        FROM AdventureWorks2016.Sales.SalesOrderHeader);
```