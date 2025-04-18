

-----------------------------------
-- This is for Powerpoint sql
-----------------------------------
USE [AdventureWorks2016]
GO

-- Page 4 , 01 About Company

-- (c) Sales Target: Worldwide / Main countries: US, Canada
-- >>> Change Profit -> SalesAmount

with
  ProfitsPerCoutry_CTE
  as
  (
    select SUM(sod.LineTotal) - (pp.StandardCost * sum(sod.OrderQty)) AS TotalProfit, pcr.Name,

      SUM(SubTotal) AS TotalSales

    from Sales.SalesOrderDetail sod
      join Production.Product pp
      on pp.ProductID=sod.ProductID
      join Sales.SalesOrderHeader soh
      on soh.SalesOrderID=sod.SalesOrderID
      join Sales.Customer c
      on c.CustomerID=soh.CustomerID
      join Person.person p
      on c.PersonID=p.BusinessEntityID
      join Person.Address pa
      on pa.AddressID=soh.ShipToAddressID
      join Person.StateProvince psp
      on psp.StateProvinceID=pa.StateProvinceID
      join Person.CountryRegion pcr
      on psp.CountryRegionCode=pcr.CountryRegionCode
    group by sod.ProductID,pp.StandardCost,pcr.Name
  )

select Name, sum(TotalProfit) as profits,

  SUM(TotalSales) AS AmountSales

from ProfitsPerCoutry_CTE
group by Name
ORDER BY AmountSales DESC

---------------------------------
