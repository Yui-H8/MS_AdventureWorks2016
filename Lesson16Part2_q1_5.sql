USE AdventureWorks2016
GO

----LESSON 16---- User-Defined Scalar Functions

-- Part 2 – Scalar functions that use variables
/*
1. For the purpose of learning, create a function called fnFuncLearning and follow the
 instructions in the following sections:
 (If the function was not deleted in the previous part of the exercise, update the
 function using "alter").
*/
/*
a. The function will take two parameters of data type int.
 b. Within the function, define a variable of type integer (int) and give it a name of
 your choice.
 c. The function will insert the result of the product of the two received
 parameters into the variable.
 d. The function will returnsthe variable that has been defined as the returned
 value.
 Call the function and send a parameter to it. Check that the result is correct
 */

CREATE OR ALTER FUNCTION fnFuncLearning 
(@Param1 INT, @Param2 INT)
RETURNS INT
AS
BEGIN

    DECLARE @result INT
    SET @result = @Param1 * @Param2
    -- !Not use! SELECT @result = @Param1 = @Param2

    RETURN @result

END

/*
 2. Create a function called fnGetOrderCustomer that takes a parameter, Order number
 (int data type), and returns the customer number from that order (int data type).
 Think of a way to check that the function is working properly, and verify that the
 result is accurate.
 3. Continue on from the previous question. In order to check the accuracy of the
 function, run the two queries below and compare the results.
 One query uses the function
 The other query performs the same calculation as the function.
 */

SELECT dbo.fnFuncLearning (10,3)

/*
 4. Create a new function called fnGetProductOrderAmount, which takes a ProductID
 and a year, and returns the SubTotal for that product in that year.
 Think what data type the function returns.
 Call the function and send a parameter. Check that the result is correct
 */

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


SELECT SUM(LineTotal)
FROM AdventureWorks2016.Sales.SalesOrderDetail sod
    JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
    AND ProductID = 712

    -----------

SELECT dbo.fnGetProductOrderAmount(2013, 712)

/*
 5. in the same way as in the previous question, create a new function called
 fnGetProductOrderQty that takes a ProductID and a year, and returns the OrderQty
 for that product in that year.
 Think what data type the function returns.
 */

CREATE OR ALTER FUNCTION fnGetProductOrderQty 
(@Year INT, @ProductID int) 
RETURNS INT
AS
BEGIN

    DECLARE @result AS INT

    SELECT @result = SUM(OrderQty)
    FROM AdventureWorks2016.Sales.SalesOrderDetail sod
        JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
   where year(OrderDate) = @year and ProductID = @Productid
   
    RETURN @result

END

------
SELECT dbo.fnGetProductOrderQty(2013, 712)


