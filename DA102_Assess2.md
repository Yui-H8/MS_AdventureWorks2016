# TECH-DA102-4 SQL for Data Analytics
## Assessment 2: Homework handbook lesson 16-17

***
*This is an appendix on the presentation of the assessment.  
It describes the queries and explanations.*
***

###  Lesson16 - User-Defined Scalar Functions
#### 1. Define a function that takes as parameters a year and a customer number, and returns the quantity of sales for that customer in that year. 

**Answer**   
LineTotal in Sales.SalesOrderHeader had a data type of “MONEY”. 

```sql
CREATE OR ALTER FUNCTION fnGetProductOrderAmount 
(@Year INT, @ProductID int) 
RETURNS DECIMAL(38,6)
AS
BEGIN

    DECLARE @result AS DECIMAL(38,6)

    SELECT @result = SUM(LineTotal)
    FROM AdventureWorks2016.Sales.SalesOrderDetail sod
        JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
    where year(OrderDate) = @year and ProductID = @Productid
    RETURN @result

END
```
To check 
```SQL
SELECT CustomerID, SUM(SubTotal) AS Totalperyear
FROM AdventureWorks2016.Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2012
    AND CustomerID = 13800
GROUP BY CustomerID
```
I will use this number to answer the question.  
The result for customer 13800 was 2443.35.  
I have a picture on the powerpoint.
```sql
---Use Fanction

SELECT dbo.fnGetcustomerSales(2012, 13800) AS Totalperyear
```


---

#### 2. Make a list of 4 functions that could be useful in the day-to-day work of a data analyst. Describe what each function does.

**Answer**  
#### 1. Show the owner's birthday from the ID.
  A preview is available on the PowerPoint.
```sql
CREATE OR ALTER FUNCTION fnGetbirthday(@busiID INT)
RETURNS DATE
AS
BEGIN 
    DECLARE @result AS DATE

    SELECT @result = BirthDATE
    FROM AdventureWorks2016.HumanResources.Employee
    WHERE BusinessEntityID = @busiID
RETURN @result
END
```
Use Function
```sql
SELECT dbo.fnGetbirthday(88) AS Birthday
```
To check
```sql
SELECT BusinessEntityID, BirthDate AS Birthday
FROM AdventureWorks2016.HumanResources.Employee
WHERE BusinessEntityID = 88
```
  
---

#### 2. The total vendor purchases for the year  

This function calculates the total vendor purchases for the year from the vendor ID and year.  
  A preview is available on the PowerPoint.
```sql
CREATE OR ALTER FUNCTION fnGetVendor (@year int, @Vendorid int)
RETURNS MONEY
AS
BEGIN
    DECLARE @result AS MONEY

    SELECT @result = SUM(LineTotal)
    FROM AdventureWorks2016.Purchasing.PurchaseOrderHeader poh
        JOIN AdventureWorks2016.Purchasing.PurchaseOrderDetail pod
        ON poh.PurchaseOrderID = pod.PurchaseOrderID
    WHERE YEAR(OrderDate) = @year and VendorID = @Vendorid
    RETURN @result
END
```
Use Function
```sql
SELECT dbo.fnGetVendor(2012, 1626) AS Sumsalesyear
```
To check
```sql
SELECT VendorID, SUM(LineTotal) AS Sumsalesyear
FROM AdventureWorks2016.Purchasing.PurchaseOrderHeader poh
    JOIN AdventureWorks2016.Purchasing.PurchaseOrderDetail pod
    ON poh.PurchaseOrderID = pod.PurchaseOrderID
WHERE VendorID = 1626 AND YEAR(OrderDate) = 2012
GROUP BY VendorID
```
---
#### 3. Total sales for the specified year and month
Enter the year, month, and SalesPersonID to display the monthly sales amount for that salesperson.  
  A preview is available on the PowerPoint.
```sql
CREATE or ALTER FUNCTION fnGetPersonSalesperMonth
    (@year INT, @month INT, @SalesPersonid INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @result AS MONEY
    SELECT @result = SUM(LineTotal)
    FROM Sales.SalesOrderHeader
    JOIN Sales.SalesOrderDetail
    ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
    WHERE year(OrderDate) = @year
        AND MONTH(OrderDate) = @month
        AND SalesPersonID = @SalesPersonid
    RETURN @result
END
```
Use Function
```sql
SELECT dbo.fnGetPersonSalesperMonth(2012, 8, 277) AS Amount
```
To check
```sql
SELECT SalesPersonID,
    YEAR(OrderDate) AS 'YEAR',
    MONTH(OrderDate) AS 'MONTH',
    SUM(LineTotal) AS Amount
FROM AdventureWorks2016.Sales.SalesOrderHeader soh
    JOIN AdventureWorks2016.Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE SalesPersonID = 277
    AND YEAR(OrderDate) = 2012
    AND MONTH(OrderDate) = 8
GROUP BY SalesPersonID, YEAR(OrderDate), MONTH(OrderDate)
```
---
#### 4. Number of customers in the specified area
Entering an area NO will display the number of customers in that area.  
A preview is available on the PowerPoint.
```sql
CREATE or ALTER FUNCTION fnGetAreaCustomerNumber
    (@AreaNo INT)
RETURNS INT
AS
BEGIN
    DECLARE @result AS INT

    SELECT @result = COUNT(DISTINCT CustomerID)
    FROM Sales.SalesTerritory
        JOIN Sales.Customer
        ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID
    WHERE Sales.SalesTerritory.TerritoryID = @AreaNo
    GROUP BY Sales.SalesTerritory.TerritoryID, Sales.SalesTerritory.[Name]

    RETURN @result
END
```
Use Function
```sql
SELECT dbo.fnGetAreaCustomerNumber(2)
```
To check
```sql
SELECT Sales.SalesTerritory.TerritoryID,
    Sales.SalesTerritory.[Name] AS 'Areaname',
    COUNT(DISTINCT CustomerID) AS 'NumberOfCustomer'
FROM Sales.SalesTerritory
    JOIN Sales.Customer
    ON Sales.Customer.TerritoryID = Sales.SalesTerritory.TerritoryID
GROUP BY Sales.SalesTerritory.TerritoryID, Sales.SalesTerritory.[Name]
```
---

###  Lesson17 - Temporary tables & Stored procedures
#### 1.  ** Challenge Question **
#### Create a procedure called spSubcategoryMinMax that executes a query based on the Products table, and displays the following data for each subcategory 
(ProductSubcategoryID):
 the ProductSubcategoryID, the ProductID with the lowest ListPrice in this
 subcategory, and the ProductID with the highest ListPrice in this sub-category.
***  
**Answer**  
```SQL

WITH
    Price_CTE
    AS
    (
        SELECT ProductSubcategoryID, ProductID, ListPrice,
            RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY Listprice ASC) AS LowID,
                        RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS HighID
        FROM production.product
        WHERE ProductSubcategoryID IS NOT NULL
    )

SELECT ProductSubcategoryID,
    MAX(CASE WHEN LowID = 1 THEN ProductID ELSE NULL END) AS MinID,
    MIN(CASE WHEN HighID = 1 THEN ProductID ELSE NULL END) AS MaxID
FROM Price_CTE
GROUP BY ProductSubcategoryID
ORDER BY ProductSubcategoryID
```
**NOTE:**   
 *There are many products in the same subcategory with the same price, and taking one out is not strictly accurate.*

**Here is a query that takes this into account.**
```sql
WITH
    Price_CTE
    AS    (
        SELECT ProductSubcategoryID, ProductID, ListPrice,
            RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY Listprice ASC) AS LowID,
                        RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS HighID
        FROM production.product
        WHERE ProductSubcategoryID IS NOT NULL
    )

SELECT ProductSubcategoryID,
    COUNT(*) AS 'Products in Subcategory',
    MAX(CASE WHEN LowID = 1 THEN ProductID ELSE NULL END) AS MinID,
    CONCAT(SUM(CASE WHEN LowID = 1 THEN 1 ELSE NULL END),' of the same price$') AS LowestProducts,
    MIN(CASE WHEN HighID = 1 THEN ProductID ELSE NULL END) AS MaxID,
    CONCAT(SUM(CASE WHEN HighID = 1 THEN 1 ELSE NULL END),' of the same price') AS HighestProducts
FROM Price_CTE
GROUP BY ProductSubcategoryID
ORDER BY ProductSubcategoryID
```
*ADD PROCEDURE*
```sql
CREATE OR ALTER PROCEDURE spSubcategoryMinMax

AS
BEGIN 
WITH
    Price_CTE
    AS    (
        SELECT ProductSubcategoryID, ProductID, ListPrice,
            RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY Listprice ASC) AS LowID,
            RANK() OVER (PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS HighID
        FROM production.product
        WHERE ProductSubcategoryID IS NOT NULL
    )

SELECT ProductSubcategoryID,
    MAX(CASE WHEN LowID = 1 THEN ProductID ELSE NULL END) AS MinID,
    MIN(CASE WHEN HighID = 1 THEN ProductID ELSE NULL END) AS MaxID
FROM Price_CTE
GROUP BY ProductSubcategoryID

END
```
---

#### 2. Call the procedure and check the correctness of the results by running the following code:
```sql
EXEC spSubcategoryMinMax
```  
   Preview is available in PowerPoint       
   
---

END