# Assessment 4: Homework handbook lesson 10

***  

###  Lesson10
#### 1. Write a query that displays the CustomerID, first name and last name of all the customers who ordered at least one product with the word "women" in its model name (Production.ProductModel table, Name column) in 2013. The word can appear at the beginning, middle or end.
#### Instructions:

#### Make sure you have included all the relevant tables in the query. Solve it using "exists".

---
*A list of products containing the word “women”.*

```SQL
    SELECT pm.[ProductModelID], pro.[ProductID], pm.[Name]
    FROM AdventureWorks2016.Production.ProductModel pm
    JOIN AdventureWorks2016.Production.Product pro
    ON pm.ProductModelID = pro.ProductModelID
    WHERE pm.[Name] LIKE 'women%'
        OR pm.[Name] LIKE '%women%'
        OR pm.[Name] LIKE '%women'
```
![](2025-03-16-10-41-45.png)
![IMAGE](https://drive.google.com/file/d/1u6aJHDfTqoC6jq98bUlnexuboReTZ4F8/view?usp=sharing "IMAGE")
---
---

*List of orders containing the above products, with EXSISTS only, since errors occurred with nesting IN functions.*

```sql
SELECT SalesOrderID
FROM AdventureWorks2016.Sales.SalesOrderDetail sod
WHERE EXISTS(
    SELECT *
    FROM (
        SELECT ProductID
        FROM AdventureWorks2016.Production.Product pro
        WHERE EXISTS(
            SELECT *
            FROM AdventureWorks2016.Production.ProductModel pm
            WHERE pm.ProductModelID = pro.ProductModelID
                AND (pm.[Name] LIKE 'women%'
                OR pm.[Name] LIKE '%women%'
                OR pm.[Name] LIKE '%women')
        )
        ) ppp
WHERE ppp.productID = sod.ProductID 
 )
```

---

* Q1 Answer code

```sql
SELECT DISTINCT soh.CustomerID, pp.FirstName, pp.LastName
FROM AdventureWorks2016.Sales.Customer sc
    JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
    ON sc.CustomerID = soh.CustomerID
    JOIN AdventureWorks2016.Person.Person pp
    ON sc.PersonID = pp.BusinessEntityID

WHERE EXISTS( 
    SELECT *
    FROM (SELECT SalesOrderID
            FROM AdventureWorks2016.Sales.SalesOrderDetail sod
            WHERE EXISTS(
                SELECT *
                FROM (
                    SELECT ProductID
                    FROM AdventureWorks2016.Production.Product pro
                    WHERE EXISTS(
                        SELECT *
                        FROM AdventureWorks2016.Production.ProductModel pm
                        WHERE pm.ProductModelID = pro.ProductModelID
                            AND (pm.[Name] LIKE 'women%'
                            OR pm.[Name] LIKE '%women%'
                            OR pm.[Name] LIKE '%women')
                                )
                    ) ppp
                WHERE ppp.productID = sod.ProductID 
                         )
        ) soID
    WHERE soID.SalesOrderID = soh.SalesOrderID
)
AND YEAR(soh.OrderDate) = 2013
GROUP BY soh.CustomerID, pp.FirstName, pp.LastName
ORDER BY soh.CustomerID;
```

---

#### 2. Continuing from the previous question, use the query and the tools learned in previous lessons to answer how many customers appeared in question 1.

* Q2 Answer    
*I used a subquery (FROM area enclosed in '()') in my previous response and an error occurred.  
Hence, I am using “CTE”.*

```sql
WITH NoOfCustomer AS (
SELECT DISTINCT soh.CustomerID, pp.FirstName, pp.LastName
FROM AdventureWorks2016.Sales.Customer sc
    JOIN AdventureWorks2016.Sales.SalesOrderHeader soh
    ON sc.CustomerID = soh.CustomerID
    JOIN AdventureWorks2016.Person.Person pp
    ON sc.PersonID = pp.BusinessEntityID

WHERE EXISTS( 
    SELECT *
    FROM (SELECT SalesOrderID
            FROM AdventureWorks2016.Sales.SalesOrderDetail sod
            WHERE EXISTS(
                SELECT *
                FROM (
                    SELECT ProductID
                    FROM AdventureWorks2016.Production.Product pro
                    WHERE EXISTS(
                        SELECT *
                        FROM AdventureWorks2016.Production.ProductModel pm
                        WHERE pm.ProductModelID = pro.ProductModelID
                            AND (pm.[Name] LIKE 'women%'
                            OR pm.[Name] LIKE '%women%'
                            OR pm.[Name] LIKE '%women')
                                )
                    ) ppp
                WHERE ppp.productID = sod.ProductID 
                         )
        ) soID
    WHERE soID.SalesOrderID = soh.SalesOrderID
)
AND YEAR(soh.OrderDate) = 2013
GROUP BY soh.CustomerID, pp.FirstName, pp.LastName

)

SELECT COUNT(*) AS 'NoOfCustomers'
FROM NoOfCustomer

```
![](2025-03-16-12-42-24.png)  
![ResultIMAGE](https://drive.google.com/file/d/13H6CwCFhRi_UTOiA3Nz56NM-kp8Pb4m_/view?usp=sharing "ResultIMAGE")
---
