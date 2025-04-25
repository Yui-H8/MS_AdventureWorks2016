USE AdventureWorks2016
GO

----LESSON 16---- User-Defined Scalar Functions
-- Part 1 Part 1– Basic scalar functions: create, alter, drop, and call the function
/*
7. Continuing from the previous section, the function will be used in 3 different
 queries.
 Write a query for each of the following sections:
*/
/*
 a. In order to check the accuracy of the function, run it with fixed parameters
 and, at the same time, calculate the expected result manually, to make sure
 that the results are identical.
 Send the following values to the function:
 Price = 100, Cost = 30, Qty = 10
 Calculate the answer manually, and check to be sure that the query returns the
 correct answer
 */

CREATE OR ALTER FUNCTION fnGetProfit 
(@Price DECIMAL(8,2), @Cost DECIMAL(8,2), @Qty INT)
RETURNS DECIMAL(8,2)

AS
BEGIN

    RETURN  @Qty * ( @Price - @Cost )

END

SELECT dbo.fnGetProfit (100, 30, 10) AS Result

/*
b. Explore the theoretical profit from each of the products in the product table.
 Send the function the following values:
 list price, item cost, and quantity = 1.
 Run the query only on products that have a value for price (price higher than
 0)
 */

SELECT productID,
dbo.fnGetProfit (ListPrice, StandardCost, 1) AS Result
FROM AdventureWorks2016.Production.Product
WHERE ListPrice > 0

/*
 c. In order to check the real profit from the Order details table, write a query that
 displays the following columns
 */

SELECT sod.SalesOrderID, pp.ProductID,
 (1- UnitPriceDiscount) * UnitPrice AS Profitafterdiscount,
 StandardCost,
 dbo.fnGetProfit  ((1- UnitPriceDiscount) * UnitPrice, StandardCost, OrderQty)
 AS ProfitSales
FROM AdventureWorks2016.Sales.SalesOrderDetail sod 
JOIN AdventureWorks2016.Production.Product pp
ON sod.ProductID = pp.ProductID

/*
d. Order number, item number, price after discount (calculated column. There are
 two ways to calculate this value.), item cost (from the Product table), profit per
 sales record (by calling the function and sending the appropriate parameters)
 */

SELECT sod.SalesOrderID, pp.ProductID,
 (1- UnitPriceDiscount) * UnitPrice AS Profitafterdiscount,
 StandardCost,
 dbo.fnGetProfit
 ((1- UnitPriceDiscount) * UnitPrice, StandardCost, OrderQty)
 AS ProfitSales
FROM AdventureWorks2016.Sales.SalesOrderDetail sod 
JOIN AdventureWorks2016.Production.Product pp
ON sod.ProductID = pp.ProductID


