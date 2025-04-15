# TECH-DA102-4 SQL for Data Analytics
## Assessment 1: Homework handbook lesson 13-15

***
*This is an appendix on the presentation of the assessment. It describes the queries and explanations.*
***

###  Lesson13 - A Data Analyst’s Workflow
#### 1. Learn independently (search the web) how to create a new table from query results.  

**Answer**  
The SELECT INTO syntax can insert query results into a new table in the current DB. This results in a new table with only the information needed from multiple data sources.  
When building the basic tables needed for analysis from a large corporate data set, it is helpful to have a table that summarizes only the information needed in advance like this.  

Reference URL : SELECT - INTO Clause (Transact-SQL)(https://learn.microsoft.com/en-us/sql/t-sql/queries/select-into-clause-transact-sql?view=sql-server-2016)

---

#### 2. Write a query that creates a new table named panel_EDA1:which contains the following data:   (Select the data from the tables that seem appropriate.)  
- SalesOrderID,
- OrderDate,
- ShipToAddressID,
- ShipDate,
- CustomerID,
- OrderQty,
- ProductID,
- LineTotal

**Answer**  

```sql
SELECT DISTINCT soh.SalesOrderID,
    soh.OrderDate,
    soh.ShipToAddressID,
    soh.ShipDate,
    soh.CustomerID,
    sod.OrderQty,
    sod.ProductID,
    sod.LineTotal

INTO panel_EDA

FROM AdventureWorks2016.Sales.SalesOrderHeader soh
    JOIN AdventureWorks2016.Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID;
```
---

#### 3. Write 5 business questions (only the questions, not the answers) that can be answered from the data in the panel_EDA1 table.  
**Answer**  
* (1) Days from order to shipment
* (2) Customer Purchase Cycle
* (3) Simultaneous purchase product combinations (basket analysis)
* (4) Times and days of the week that sell well
* (5) Identifying Repeat Customers

***  
  
###  Lesson14 - DML (Data Manipulation Language) and Import/Export to csv file
*After each section, be sure to check that what you did works, and that the data has changed! 
You will work as an analyst. Checking your work is necessary and critical for your professional credibility.*  

#### 1. Check that you have a database called Test_DML.  
**Answer**  
Image on PowerPoint

#### 2. In the Test_DML database, create a table with the same format as the Order header table, with all the data about the orders in 2011.  ( Name the table SalesOrderHeader2011. )
**Answer**  
```sql
-- In the Test_DML
USE Test_DML
GO

-- Q2 Create new table : SalesOrderHeader2011 --
SELECT *

INTO SalesOrderHeader2011

FROM AdventureWorks2016.Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-01-01' AND '2011-12-31'
```

#### 3. In the Test_DML database, create a table with the same format as the Order details table, with all the order records for 2011. (Name the table SalesOrderDetail2011. )
**Answer**  
```sql
-- Q3 Create new table : SalesOrderDetail2011 / 5716 row
SELECT *

INTO SalesOrderDetail2011

FROM AdventureWorks2016.Sales.SalesOrderDetail sod
WHERE EXISTS (
SELECT *
FROM AdventureWorks2016.Sales.SalesOrderHeader soh
WHERE sod.SalesOrderID = soh.SalesOrderID
    AND soh.OrderDate BETWEEN '2011-01-01' AND '2011-12-31'
) 

---- CHECK query : 5716 row ----
-- If JOIN all column from 2 table --

SELECT *
FROM AdventureWorks2016.Sales.SalesOrderHeader soh
    JOIN AdventureWorks2016.Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE OrderDate BETWEEN '2011-01-01' AND '2011-12-31'
```

#### 4. Now begin to work on the new DB: Test_DML
**Answer**  
```sql
-- In the Test_DML
USE Test_DML
GO
```
#### 5.  Change the date of all the orders from the month of May to the date  31-01-2011.
**Answer**  
```sql
-- Q5 Pre-heck - Date range at 'SalesOrderHeader2011' --
SELECT MIN(OrderDate) AS MinDate,
    MAX(OrderDate) AS MaxDate,
    DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)) AS Daterange
FROM SalesOrderHeader2011
```
Update OrderDate of all the orders
```sql
UPDATE SalesOrderHeader2011
SET OrderDate = '2011-01-31'
WHERE OrderDate BETWEEN '2011-05-01' AND '2011-05-31'
```
#### 6. Check that section 5 worked properly. How can this be checked?
**Answer**  
Comparison with the results of the pre-check shows that all dates in the table have been changed.

```SQL
-- Q6 After check - Date range at 'SalesOrderHeader2011' --
SELECT MIN(OrderDate) AS MinDate,
    MAX(OrderDate) AS MaxDate,
    DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)) AS Daterange
FROM SalesOrderHeader2011;

-- After run, no order in May 
SELECT MIN(OrderDate) AS MinDate,
    MAX(OrderDate) AS MaxDate
FROM SalesOrderHeader2011
WHERE OrderDate BETWEEN '2011-05-01' AND '2011-05-31';
```

***
###  Lesson15 - DDL (Data Definition Language) and View  
*After each section, be sure to check that what you did works, and that the data has changed! 
You will work as an analyst. Checking your work is necessary and critical for your professional credibility.*  


***

####  1. Check that you have a database called Test_DML. (It was created during the class practice.)  
**Answer**  
Image on PowerPoint
#### 2. Now begin to work on the new DB: Test_DML
**Answer**  
```sql
-- Go to the Test_DML
USE Test_DML
GO
```


#### 3. Create a new table named "student" (with commands or with the UI) that contains 3 fields:  

* a. Student number (int) - primary key
* b. First name - string 15
* c. Last name - string 15   
**Answer**  
```sql
-- Q3 CREATE new table

CREATE TABLE student
(
    Studentnumber INT PRIMARY KEY,
    Firstname NVARCHAR(15),
    Lastname NVARCHAR(15)
)
```

#### 4. Add a nonclustered index to the student table. 
The index will be on the First name and then on the Last name.  
**Answer** 

```sql
CREATE INDEX IX_student_FirstName_LastName
ON student
(
    Firstname asc,
    Lastname asc
)
```
#### 5. Add another field called "Email", a string 255 type, to the new Student table.  
**Answer** 
```SQL
ALTER TABLE student
 ADD Email NVARCHAR(255)

-- For Check
SELECT *
FROM student
```
#### 6. Add two records to the student table: the first with your details, and the second with another student's details.
  **Answer** 
```SQL
INSERT INTO student
    (Studentnumber,FirstName, LastName, Email)
VALUES
    ( 1, 'Yui', 'Hanamura', 'vg024904@ilsceducation.com'),
    ( 2, 'Noan', 'Morchi', 'test811@adventure-works.com');

```
#### 7. Change the second student's last name to a new last name.   
**Answer** 
```sql
UPDATE student
SET Lastname = 'Tanaka'
WHERE Studentnumber = 2
```
#### 8. Change the other student's email to his or her email address  
**Answer** 
```sql
UPDATE student
SET Email = 'test811@adventure-works.com'
WHERE Studentnumber = 1
```
#### 9. After reexamining the table structure, it was decided that there is no need for the Email column, so please remove the Email column from the Student table.
  **Answer** 
```sql
ALTER TABLE student
DROP COLUMN Email

-- check

SELECT *
FROM student
```


#### 10. Go back to the AdventureWorks database we usually work with, and create a VIEW called vSaleItemDetails that contains the detailed order data,   
**Answer** 
```sql
USE AdventureWorks2016
GO
```
i.e., a combination of the data from Order details, Order header, Customer data and Product details, as follows:
* a. Order details: Order number, Discounted item price (calculated), Total
* payment per order.
* b. Order header: Order Date, Customer ID.
* c. Persons table: First name, Last name.
* d. Items table: Item name, Item color.
```sql
CREATE OR ALTER VIEW vSaleItemDetails
AS

    SELECT sod.SalesOrderID,
        sod.UnitPrice - (sod.UnitPrice * sod.UnitPriceDiscount) AS 'Discounted_itemPrice',
        sod.LineTotal AS 'TotalpayOrder',
        soh.OrderDate,
        soh.CustomerID,
        pep.FirstName,
        pep.LastName,
        prp.[Name] AS 'ProductName',
        prp.Color
    FROM AdventureWorks2016.Sales.SalesOrderHeader soh
        JOIN AdventureWorks2016.Sales.SalesOrderDetail sod
        ON soh.SalesOrderID = sod.SalesOrderID
        JOIN AdventureWorks2016.Sales.Customer sc
        ON soh.CustomerID = sc.CustomerID
        JOIN AdventureWorks2016.Person.Person pep
        ON sc.PersonID = pep.BusinessEntityID
        JOIN AdventureWorks2016.Production.Product prp
        ON sod.ProductID = prp.ProductID
```
Image on PowerPoint

#### 11. Such a VIEW can make which calculations, reports or statistics easier?  
**Answer**   
Yes.
- Customer preferences (color and size). 
- When products sell well. Sales of seasonal products. 
- Correlation between discount rates and sales.   

Also, storing views makes it easier to share information with my team.

#### 12. Prepare a list of 3 Views that you think will be useful in your regular work as an analyst. Describe in general terms what the purpose of the VIEW is, what it should contain and what can be deduced from it
  **Answer** 
#### View1: Sales Ranking by Category in 2012
*Objective* : To understand the company's most popular products
*Description* : Product name, category, date of purchase, sales  
*Goal* : Utilize for future sales strategy  

Knowing popular products will help you understand your company's strengths.

```sql
CREATE OR ALTER VIEW vSalesRankingCategory2012
AS

SELECT TOP(5)
(CASE WHEN pc.ProductCategoryID IS NOT NULL THEN MAX(pc.[Name]) ELSE NULL END) AS 'Category',
RANK() OVER(PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.LineTotal) DESC) AS 'Ranking2012',
(CASE WHEN ps.ProductSubcategoryID IS NOT NULL THEN MAX(ps.[Name]) ELSE NULL END) AS 'SubCategory',
(CASE WHEN pp.ProductID IS NOT NULL THEN MAX(pp.[Name]) ELSE NULL END) AS 'Product',
SUM(sod.LineTotal) AS 'Total'
FROM AdventureWorks2016.Production.Product pp
JOIN AdventureWorks2016.Production.ProductSubcategory ps 
ON pp.ProductSubcategoryID= ps.ProductSubcategoryID
JOIN AdventureWorks2016.Production.ProductCategory pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN AdventureWorks2016.Sales.SalesOrderDetail sod 
ON pp.ProductID = sod.ProductID
JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2012-01-01' AND '2012-12-31' 
AND pc.ProductCategoryID = 1
GROUP BY pc.ProductCategoryID, ps.ProductSubcategoryID, pp.ProductID

UNION ALL

SELECT TOP(5)
(CASE WHEN pc.ProductCategoryID IS NOT NULL THEN MAX(pc.[Name]) ELSE NULL END) ,
RANK() OVER(PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.LineTotal) DESC) ,
(CASE WHEN ps.ProductSubcategoryID IS NOT NULL THEN MAX(ps.[Name]) ELSE NULL END) ,
(CASE WHEN pp.ProductID IS NOT NULL THEN MAX(pp.[Name]) ELSE NULL END) ,
SUM(sod.LineTotal)
FROM AdventureWorks2016.Production.Product pp
JOIN AdventureWorks2016.Production.ProductSubcategory ps 
ON pp.ProductSubcategoryID= ps.ProductSubcategoryID
JOIN AdventureWorks2016.Production.ProductCategory pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN AdventureWorks2016.Sales.SalesOrderDetail sod 
ON pp.ProductID = sod.ProductID
JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2012-01-01' AND '2012-12-31' 
AND pc.ProductCategoryID = 2
GROUP BY pc.ProductCategoryID, ps.ProductSubcategoryID, pp.ProductID

UNION ALL

SELECT TOP(5)
(CASE WHEN pc.ProductCategoryID IS NOT NULL THEN MAX(pc.[Name]) ELSE NULL END) ,
RANK() OVER(PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.LineTotal) DESC) ,
(CASE WHEN ps.ProductSubcategoryID IS NOT NULL THEN MAX(ps.[Name]) ELSE NULL END) ,
(CASE WHEN pp.ProductID IS NOT NULL THEN MAX(pp.[Name]) ELSE NULL END) ,
SUM(sod.LineTotal)
FROM AdventureWorks2016.Production.Product pp
JOIN AdventureWorks2016.Production.ProductSubcategory ps 
ON pp.ProductSubcategoryID= ps.ProductSubcategoryID
JOIN AdventureWorks2016.Production.ProductCategory pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN AdventureWorks2016.Sales.SalesOrderDetail sod 
ON pp.ProductID = sod.ProductID
JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2012-01-01' AND '2012-12-31' 
AND pc.ProductCategoryID = 3
GROUP BY pc.ProductCategoryID, ps.ProductSubcategoryID, pp.ProductID

UNION ALL 

SELECT TOP(5)
(CASE WHEN pc.ProductCategoryID IS NOT NULL THEN MAX(pc.[Name]) ELSE NULL END) ,
RANK() OVER(PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.LineTotal) DESC) ,
(CASE WHEN ps.ProductSubcategoryID IS NOT NULL THEN MAX(ps.[Name]) ELSE NULL END) ,
(CASE WHEN pp.ProductID IS NOT NULL THEN MAX(pp.[Name]) ELSE NULL END) ,
SUM(sod.LineTotal)
FROM AdventureWorks2016.Production.Product pp
JOIN AdventureWorks2016.Production.ProductSubcategory ps 
ON pp.ProductSubcategoryID= ps.ProductSubcategoryID
JOIN AdventureWorks2016.Production.ProductCategory pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN AdventureWorks2016.Sales.SalesOrderDetail sod 
ON pp.ProductID = sod.ProductID
JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2012-01-01' AND '2012-12-31' 
AND pc.ProductCategoryID = 4
GROUP BY pc.ProductCategoryID, ps.ProductSubcategoryID, pp.ProductID
```
**Preview is in PowerPoint**




---

#### View2: Sales area and name of person
Sales area and name of person in charge, age, and job name. 

*Purpose* : Information sharing  
*Description*: Country, sales person, name, age, title  
*Goal* : Reduce search time   

For large companies, the sales region and the name of the person in charge are often not well known. This view facilitates information sharing. 

```sql
CREATE OR ALTER VIEW vSalesAreaPerson
AS

SELECT
    pcr.CountryRegionCode AS 'Country',
    sty.[Name],
    pp.FirstName,
    pp.LastName,
    DATEDIFF(YEAR, hre.BirthDate, GETDATE()) AS 'Age',
    hre.JobTitle
FROM AdventureWorks2016.Sales.SalesTerritory sty
    JOIN AdventureWorks2016.Sales.SalesPerson sap
    ON sty.TerritoryID = sap.TerritoryID
    JOIN AdventureWorks2016.Person.CountryRegion pcr
    ON sty.CountryRegionCode = pcr.CountryRegionCode
    JOIN AdventureWorks2016.Person.Person pp
    ON sap.BusinessEntityID = pp.BusinessEntityID
    JOIN AdventureWorks2016.HumanResources.Employee hre
    ON sap.BusinessEntityID = hre.BusinessEntityID
```
**Preview is in PowerPoint**

---
#### View3: Sales Ranking by Store in 2012
*Purpose*: To know which stores and countries have sales
*Description*: Country, store name, category, date of purchase, sales  
*Goal* : Share information, motivate

Identifying stores with sales will provide hints for sales strategies and inspire other stores.

```sql
CREATE OR ALTER VIEW vSalesRankingStore2012
AS

SELECT TOP(20)
    ste.CountryRegionCode AS 'Country',
    sac.StoreID,
    sst.[Name],
    SUM(soh.SubTotal) AS 'StoreSales',
    DENSE_RANK() OVER (ORDER BY SUM(soh.SubTotal) DESC) AS 'Rank2012'
FROM AdventureWorks2016.Sales.Customer sac
    JOIN AdventureWorks2016.Sales.Store sst
    ON sac.StoreID = sst.BusinessEntityID
    JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
    ON soh.CustomerID = sac.CustomerID
    JOIN AdventureWorks2016.Sales.SalesTerritory ste 
    ON ste.TerritoryID = sac.TerritoryID
WHERE soh.OrderDate BETWEEN '2012-01-01' AND '2012-12-31'
GROUP BY sac.StoreID, sst.[Name], ste.CountryRegionCode
```
**Preview is in PowerPoint**  

---