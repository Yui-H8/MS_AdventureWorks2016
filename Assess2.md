## Assessment 2: Homework handbook lesson 4-7
  
***

####  Lesson4 
* Q1 

```sql
SELECT ProductID, SUM(OrderQty) AS TotalQuantity
FROM AdventureWorks2016.Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) BETWEEN '600' AND '850';
```
  

* Q2 
 Note: NULLs were removed and the result was zero.  
  This is not accurate on the table, so NULLs were eliminated first.


```sql
SELECT Title, COUNT(Title) AS NumberofTitle
FROM AdventureWorks2016.Person.Person
WHERE Title IS NOT NULL
GROUP BY Title
ORDER BY NumberofTitle DESC;
```
***

####  Lesson5 
* Q1 
```SQL
SELECT BusinessEntityID, FirstName, MiddleName, LastName, ModifiedDate
FROM AdventureWorks2016.Person.Person
WHERE FirstName LIKE '%O'
    AND ModifiedDate NOT BETWEEN '2008-03-01' AND '2008-12-01'
ORDER BY BusinessEntityID, ModifiedDate;
```

* Q2 
```sql
SELECT ProductID
FROM AdventureWorks2016.Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) BETWEEN '600' and '850'
ORDER BY ProductID;
```

***

####  Lesson6   
* Q1 
```SQL
SELECT TOP (3)
    a.ProductID, b.Color, SUM(a.OrderQty) AS Amountobuy
FROM AdventureWorks2016.Sales.SalesOrderDetail a
    LEFT JOIN AdventureWorks2016.Production.Product b
    ON a.ProductID = b.ProductID
WHERE b.Color IS NOT NULL
GROUP BY a.ProductID, b.Color
ORDER BY Amountobuy DESC;
```

* Q2 

```SQL
SELECT TOP(10)
    c.SubTotal,
    b.LastName,
    b.FirstName,
    c.OrderDate
FROM AdventureWorks2016.Sales.Customer a
    JOIN AdventureWorks2016.Person.Person b
    ON a.PersonID = b.BusinessEntityID
    JOIN AdventureWorks2016.Sales.SalesOrderHeader c
    ON a.CustomerID = c.CustomerID
WHERE YEAR(c.OrderDate) = 2013
    AND b.FirstName IS NOT NULL
    AND b.LastName IS NOT NULL
    AND ( b.LastName LIKE '%lan%'
    OR b.LastName LIKE 'lan%' OR b.LastName LIKE '%lan')
    AND ( b.FirstName NOT LIKE '%r%'
    AND b.FirstName NOT LIKE '%r' AND b.FirstName NOT LIKE 'r%')
ORDER BY c.SubTotal DESC;
```

* Q3 

```SQL
SELECT p.ProductID, p.[Name]
FROM AdventureWorks2016.Production.Product p
    FULL OUTER JOIN AdventureWorks2016.Sales.SalesOrderDetail s
    ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL
```

####  Lesson7   
* Q1  

```SQL
SELECT b.ProductID,
    SUM(b.OrderQty) AS NoOfSales,
    COUNT(b.OrderQty) AS TotalQty,
    CASE 
    WHEN AVG(b.OrderQty) < 3 THEN 'Low quantity'
    WHEN AVG(b.OrderQty) <= 6 THEN 'Reasonable quantity'
    WHEN AVG(b.OrderQty) > 6 THEN 'High quantity'
    ELSE NULL END AS 'AvgQtyDescribe'
FROM AdventureWorks2016.Sales.SalesOrderHeader a
    LEFT JOIN AdventureWorks2016.Sales.SalesOrderDetail b
    ON a.SalesOrderID = b.SalesOrderID
WHERE YEAR(a.OrderDate) = 2012 AND MONTH(a.OrderDate) = 05
GROUP BY b.ProductID
ORDER BY AVG(b.OrderQty) DESC;
```