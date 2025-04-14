--  Lesson2 Q1 (Result: Row 7987)

SELECT SalesOrderNumber, OrderDate, CustomerID, SubTotal
FROM AdventureWorks2016.Sales.SalesOrderHeader
WHERE SubTotal >= '1500' AND OrderDate >= '2013-01-01';

--  Lesson2 Q2 (Result: Row 45)

SELECT *
FROM AdventureWorks2016.Person.Person
WHERE BusinessEntityID >= '10000'
AND FirstName IN ('Jack','Crystal');

--  Lesson2 Q3 (Result: Row 31504)

SELECT SalesOrderID, ProductID, LineTotal
FROM AdventureWorks2016.Sales.SalesOrderDetail
WHERE LineTotal BETWEEN '100' AND '1000';

---------------------------------------------------------

--  Lesson3 Q1 (Result: Row 205)

SELECT ProductID,
    [Name] AS Product_Name,
    Color,
    [Weight],
    ListPrice - StandardCost AS Profit_margin
FROM AdventureWorks2016.Production.Product
WHERE [Weight] <> 0
ORDER BY Color DESC, [Weight] ASC; 

--  Lesson3 Q2 (Result: Row 31465)

SELECT SalesOrderID, SubTotal AS Order_amount, 
SubTotal + 50 AS SubTotalPlus50 
FROM AdventureWorks2016.Sales.SalesOrderHeader
ORDER BY Order_amount DESC;

