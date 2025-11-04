-- ========= SCHEMA =========

-- 1. Customers Table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL,
  PasswordHash VARCHAR(255) NOT NULL,
  JoinDate DATE
);

-- 2. CustomerAddresses Table
CREATE TABLE CustomerAddresses (
  AddressID INT PRIMARY KEY,
  CustomerID INT,
  AddressLine1 TEXT NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL,
  Pincode VARCHAR(10) NOT NULL,
  IsDefault BOOLEAN DEFAULT 0,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 3. Categories Table
CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(100) NOT NULL,
  ParentCategoryID INT, -- For sub-categories
  FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

-- 4. Products Table
CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Description TEXT,
  CategoryID INT,
  Price DECIMAL(10, 2) NOT NULL,
  StockQuantity INT NOT NULL DEFAULT 0,
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 5. Orders Table (Transaction Header)
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATETIME NOT NULL,
  ShippingAddressID INT,
  TotalAmount DECIMAL(10, 2),
  OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Shipped', 'Delivered', 'Cancelled'
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (ShippingAddressID) REFERENCES CustomerAddresses(AddressID)
);

-- 6. OrderItems Table (Transaction Details)
CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY,
  OrderID INT,
  ProductID INT,
  Quantity INT NOT NULL,
  PricePerUnit DECIMAL(10, 2) NOT NULL, -- Price at the time of sale
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 7. Payments Table
CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY,
  OrderID INT,
  PaymentDate DATETIME NOT NULL,
  PaymentMethod VARCHAR(50) NOT NULL, -- 'Credit Card', 'UPI', 'COD'
  TransactionStatus VARCHAR(20) NOT NULL, -- 'Success', 'Failed', 'Pending'
  Amount DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Query 1: Find the Top 5 Best-Selling Products by Quantity
SELECT
  P.Name,
  SUM(OI.Quantity) AS TotalSold
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalSold DESC
LIMIT 5;

-- Query 2: Calculate Total Revenue by Main Category
-- This query joins 5 tables and uses the ParentCategoryID
SELECT
  C_Main.CategoryName,
  SUM(OI.Quantity * OI.PricePerUnit) AS CategoryRevenue
FROM OrderItems OI
JOIN Products P ON OI.ProductID = P.ProductID
JOIN Categories C_Sub ON P.CategoryID = C_Sub.CategoryID
JOIN Categories C_Main ON C_Sub.ParentCategoryID = C_Main.CategoryID
JOIN Orders O ON OI.OrderID = O.OrderID
WHERE O.OrderStatus = 'Delivered' -- Only count completed sales
GROUP BY C_Main.CategoryName
ORDER BY CategoryRevenue DESC;

-- Query 3: Find Customers Who Haven't Placed an Order in 30 Days (for re-engagement)
-- (Using SQLite syntax for date)
SELECT
  C.Name,
  C.Email,
  MAX(O.OrderDate) AS LastOrderDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name, C.Email
HAVING LastOrderDate < DATE('now', '-30 days') OR LastOrderDate IS NULL;

-- Query 4: Monthly Sales Growth Percentage (using CTE and Window Function)
WITH MonthlySales AS (
  SELECT
    strftime('%Y-%m', OrderDate) AS SaleMonth,
    SUM(TotalAmount) AS MonthlyRevenue
  FROM Orders
  WHERE OrderStatus IN ('Delivered', 'Shipped') -- Include shipped items
  GROUP BY SaleMonth
),
LaggedSales AS (
  SELECT
    SaleMonth,
    MonthlyRevenue,
    LAG(MonthlyRevenue, 1, 0) OVER (ORDER BY SaleMonth) AS PreviousMonthRevenue
  FROM MonthlySales
)
SELECT
  SaleMonth,
  MonthlyRevenue,
  PreviousMonthRevenue,
  ( (MonthlyRevenue - PreviousMonthRevenue) * 100.0 / PreviousMonthRevenue ) AS GrowthPercentage
FROM LaggedSales
WHERE PreviousMonthRevenue > 0;

-- Query 5: Find the Average Order Value (AOV)
SELECT
  SUM(TotalAmount) / COUNT(OrderID) AS AverageOrderValue
FROM Orders
WHERE OrderStatus = 'Delivered';

-- Query 6: Identify High-Value Customers (Total Spend > 10000)
SELECT
  C.Name,
  C.Email,
  SUM(O.TotalAmount) AS TotalSpend
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderStatus = 'Delivered'
GROUP BY C.CustomerID, C.Name, C.Email
HAVING TotalSpend > 10000
ORDER BY TotalSpend DESC;

-- Query 7: Find Orders with Failed Payments
SELECT
  O.OrderID,
  C.Name,
  O.OrderDate,
  P.PaymentMethod,
  P.Amount
FROM Payments P
JOIN Orders O ON P.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE P.TransactionStatus = 'Failed';

-- Query 8: Check Product Inventory for items with low stock
SELECT
  ProductID,
  Name,
  StockQuantity
FROM Products
WHERE StockQuantity < 25;
