USE AdventureWorks2016
GO

----LESSON 16---- User-Defined Scalar Functions
-- Part 1 Part 1– Basic scalar functions: create, alter, drop, and call the function
/*
 4. Modify the fnFuncLearning function so it takes two parameters of type int, and
 returns the product of the first parameter multiplied by the second.
 Call the function and send a parameter. Check that the result is correct
 Reminder: To call a function with more than one parameter, separate the parameters
 with a comma. For example:
 selectdbo.fnFuncLearning(12, 5)as Resul
 */

CREATE OR ALTER FUNCTION fnFuncLearning 
(@number1 INT, @number2 INT)
RETURNS INT
AS
BEGIN
    RETURN @number1 * @number2
END

SELECT dbo.fnFuncLearning(12, 5) AS Result

--- SAME

CREATE OR ALTER FUNCTION fnFuncLearning 
(@number1 INT, @number2 INT)
RETURNS INT
AS
BEGIN
    -- DECLARE @result INT
    -- SET @result =  @number1 * @number2
    -- RETURN @result


    RETURN @number1 * @number2
END

SELECT dbo.fnFuncLearning(12, 5) AS Result

/*
 5. The preliminary practice is complete, so there is no further need for the
 fnFuncLearning function. Delete the function.
*/
DROP FUNCTION fnFuncLearning

/*
6. Create a new function called fnGetProfit that takes 3 parameters: price, cost and
 quantity (more details below), and calculates the profit for all items
*/

CREATE OR ALTER FUNCTION fnGetProfit 
(@Price DECIMAL(8,2), @Cost DECIMAL(8,2), @Qty INT)
RETURNS DECIMAL(8,2)

AS
BEGIN

    RETURN  @Qty * ( @Price - @Cost )

END

SELECT dbo.fnGetProfit (1000, 250, 5) AS Result