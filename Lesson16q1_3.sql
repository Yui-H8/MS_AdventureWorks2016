USE AdventureWorks2016
GO

----LESSON 16---- User-Defined Scalar Functions
-- Part 1 Part 1– Basic scalar functions: create, alter, drop, and call the function
/*
1. Create a function called fnFuncLearning that does not take parameters and returns
 integer values (type int).
 Set the function to always return the number 2.
 Call the function and check that it returns the correct value
*/

CREATE OR ALTER FUNCTION fnFuncLearning ()
RETURNS INT
AS
BEGIN
    RETURN 2
END

SELECT dbo.fnFuncLearning()

/* Q2
 2. Modify the fnFuncLearning function so that it returns the result of the following
 formula (Do not calculate the result yourself. Let the function do the calculation.):
 6 +2*(4-2 * 3)
 Call the function, and check the accuracy)
*/

CREATE OR ALTER FUNCTION fnFuncLearning 
(@number1 INT, @number2 INT, @number3 INT, @number4 INT)
RETURNS INT
AS
BEGIN
    RETURN @number1 + @number2 * (@number3 - @number2 * @number4)
END

SELECT dbo.fnFuncLearning(6,2,4,3)

/*
3. Modify the fnFuncLearning function so that it takes a parameter of type int. Decide
 on a parameter name.
 Modify the function's operation so that the result it returns is the parameter (the
 value sent to the function in the parameter) multiplied (*) by 10.
 Call the function and send a parameter. Check that the result is correct.
 Reminder: When calling a function with a parameter, write the parameter inside
 parentheses. For example:
 selectdbo.fnFuncLearning(5)as Resul
*/

CREATE OR ALTER FUNCTION fnFuncLearning (@number1 INT)
RETURNS INT
AS
BEGIN
    RETURN @number1 * 10
END

SELECT dbo.fnFuncLearning(5)