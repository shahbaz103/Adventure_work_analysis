
-- 1. TOTAL SALES  
   
    SELECT 
    CONCAT('$ ', FORMAT(SUM(UnitPrice * OrderQuantity) / 1000000, 2), 'M') AS TotalSales
FROM 
    (
        SELECT UnitPrice, OrderQuantity FROM Sales
        UNION ALL
        SELECT UnitPrice, OrderQuantity FROM Salesn
    ) AS totalSales;


-- 2. TOTAL PROFIT

SELECT 
    CONCAT('$ ', FORMAT(SUM((UnitPrice * OrderQuantity) - totalProductCost) / 1000000, 2), 'M') AS TotalProfit
FROM 
    (
        SELECT UnitPrice, OrderQuantity, totalProductCost FROM Sales
        UNION ALL
        SELECT UnitPrice, OrderQuantity, totalProductCost FROM Salesn
    ) AS totalSales;


-- 3. TOTAL CUSTOMERS

SELECT 
    CONCAT(ROUND(COUNT(Customerkey) / 1000), 'K') AS TotalCustomers
FROM Customers;

-- 4. TOTAL SALES BY REGION

SELECT 
    t.SalesTerritoryRegion,
    CONCAT('$ ', FORMAT(SUM(s.SalesAmount) / 1000, 1), 'K') AS TotalSales
FROM 
    (
        SELECT SalesAmount, SalesTerritoryKey FROM Sales
        UNION ALL
        SELECT SalesAmount, SalesTerritoryKey FROM Salesn
    ) AS s
JOIN 
    territory t ON s.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY 
    t.SalesTerritoryRegion;

-- 5. PRODUCTION COST

SELECT 
    CONCAT('$ ', FORMAT(SUM(s.SalesAmount * 0.60) / 1000000, 2), 'M') AS TotalProductionCost
FROM 
    (
        SELECT SalesAmount FROM Sales
        UNION ALL
        SELECT SalesAmount FROM SalesN
    ) AS s;


-- 6. TOTAL ORDERS 

SELECT 
    CONCAT(round(COUNT(DISTINCT s.salesordernumber) / 1000), 'K') AS TotalOrders
FROM 
    (
        SELECT salesordernumber FROM Sales
        UNION ALL
        SELECT salesordernumber FROM Salesn
    ) AS s;

-- 7. TOTAL UNIQUE PRODUCT

SELECT COUNT(DISTINCT productkey) AS total_product
FROM (
    SELECT productkey FROM sales
    UNION
    SELECT productkey FROM salesn
) AS s;

-- 8. TOP 10 CUSTOMER NAMES BY SALES

SELECT 
    CONCAT(c.firstname, ' ', c.middlename, ' ', c.lastname) AS CustomerName,
    CONCAT('$', FORMAT(SUM(s.salesamount) / 1000, 2), 'k') AS TotalSales
FROM 
    Customers c
JOIN 
    (
        SELECT customerkey, salesamount FROM Sales
        UNION ALL
        SELECT customerkey, salesamount FROM Salesn
    ) s ON c.customerkey = s.customerkey
GROUP BY 
    c.customerkey
ORDER BY 
    SUM(s.salesamount) DESC
LIMIT 10;

-- 9. TOP 3 SUB-CATEGORY PRODUCT BY SALES

SELECT 
    pr.EnglishProductSubcategoryName as sub_category, 
    CONCAT('$ ', FORMAT(SUM(s.salesamount) / 1000000, 2), 'M') AS TotalSales
FROM 
    productsubcategory pr
JOIN 
    Products p ON pr.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN 
    (
        SELECT productkey, salesamount FROM Sales
        UNION ALL
        SELECT productkey, salesamount FROM Salesn
    ) s ON p.productkey = s.productkey
GROUP BY 
   sub_category
ORDER BY 
    SUM(s.salesamount) DESC
LIMIT 3;

-- 10. SALES VS PRODUCTION COST

SELECT 
    CONCAT('$ ', FORMAT(SUM(s.sales_amount) / 1000000, 2), 'M') AS TotalSales,
    CONCAT('$ ', FORMAT(SUM(s.production_cost) / 1000000, 2), 'M') AS TotalProductionCost
FROM 
    (
        SELECT salesamount AS sales_amount, productstandardcost AS production_cost FROM Sales
        UNION ALL
        SELECT salesamount AS sales_amount, productstandardcost AS production_cost FROM Salesn
    ) s;

-- 11. NUMBER OF ORDERS

SELECT CONCAT(FORMAT(COUNT(DISTINCT salesordernumber) / 1000,0), ' k') AS total_orders
FROM (
    SELECT salesordernumber FROM sales
    UNION all
    SELECT salesordernumber FROM salesn
) AS combined_sales;


-- 12. TOP PRODUCT BY ORDERS


SELECT 
    p.EnglishProductName,
    CONCAT(FORMAT(COUNT(DISTINCT c_sales.salesordernumber) / 1000, 1), ' k') AS total_orders
FROM 
    products p
LEFT JOIN  (
    SELECT salesordernumber, productkey FROM Sales
    UNION
    SELECT salesordernumber, productkey FROM Salesn
) AS c_sales ON p.productkey = c_sales.productkey
GROUP BY 
    p.EnglishProductName
ORDER BY 
    total_orders DESC
    LIMIT 10;
























