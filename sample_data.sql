-- ========= SAMPLE DATA =========

-- Categories (with Sub-categories)
INSERT INTO Categories (CategoryID, CategoryName, ParentCategoryID) VALUES
(1, 'Electronics', NULL),
(2, 'Books', NULL),
(3, 'Clothing', NULL),
(4, 'Smartphones', 1),
(5, 'Laptops', 1),
(6, 'Fiction', 2),
(7, 'Non-Fiction', 2),
(8, 'Men''s', 3),
(9, 'Women''s', 3);

-- Customers
INSERT INTO Customers (CustomerID, Name, Email, PasswordHash, JoinDate) VALUES
(1, 'Ravi Kumar', 'ravi.k@example.com', 'hash123', '2024-01-15'),
(2, 'Anjali Sharma', 'anjali.s@example.com', 'hash456', '2024-02-20'),
(3, 'Amit Verma', 'amit.v@example.com', 'hash789', '2024-03-05'),
(4, 'Sunita Patel', 'sunita.p@example.com', 'hash101', '2024-05-10'),
(5, 'Vikram Singh', 'vikram.s@example.com', 'hash112', '2024-07-22');

-- CustomerAddresses
INSERT INTO CustomerAddresses (AddressID, CustomerID, AddressLine1, City, State, Pincode, IsDefault) VALUES
(1, 1, '123 Arera Colony', 'Bhopal', 'Madhya Pradesh', '462016', 1),
(2, 2, '456 Vijay Nagar', 'Indore', 'Madhya Pradesh', '452001', 1),
(3, 3, '789 Civil Lines', 'Jabalpur', 'Madhya Pradesh', '482001', 1),
(4, 4, '101 Kolar Road', 'Bhopal', 'Madhya Pradesh', '462042', 1),
(5, 5, '202 Palasia', 'Indore', 'Madhya Pradesh', '452002', 1),
(6, 1, 'C-10, MP Nagar', 'Bhopal', 'Madhya Pradesh', '462011', 0); -- Ravi's office address

-- Products
INSERT INTO Products (ProductID, Name, Description, CategoryID, Price, StockQuantity) VALUES
(1, 'Pixel 8 Pro', 'The latest Google flagship phone', 4, 79999.00, 50),
(2, 'MacBook Air M3', '13-inch laptop with M3 chip', 5, 114900.00, 30),
(3, 'The Silent Patient', 'A psychological thriller', 6, 350.00, 150),
(4, 'Atomic Habits', 'Self-help book by James Clear', 7, 499.00, 200),
(5, 'Men''s Blue T-Shirt', 'Cotton round-neck t-shirt', 8, 599.00, 300),
(6, 'Women''s Denim Jacket', 'Classic blue denim jacket', 9, 1999.00, 100),
(7, 'Samsung Galaxy S24', 'AI-powered smartphone', 4, 84999.00, 45),
(8, 'Dell XPS 15', 'High-performance laptop', 5, 149900.00, 20),
(9, 'Dune', 'Sci-fi novel by Frank Herbert', 6, 450.00, 120),
(10, 'Men''s Chinos', 'Beige cotton chinos', 8, 1499.00, 180);

-- Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, ShippingAddressID, TotalAmount, OrderStatus) VALUES
(1001, 1, '2025-10-01 10:30:00', 1, 3998.00, 'Delivered'),
(1002, 2, '2025-10-03 14:15:00', 2, 84999.00, 'Delivered'),
(1003, 1, '2025-10-05 09:00:00', 6, 114900.00, 'Shipped'),
(1004, 3, '2025-10-05 17:45:00', 3, 949.00, 'Delivered'),
(1005, 4, '2025-10-06 11:10:00', 4, 1999.00, 'Pending'),
(1006, 5, '2025-10-07 12:00:00', 5, 350.00, 'Shipped'),
(1007, 2, '2025-11-01 10:00:00', 2, 599.00, 'Delivered'),
(1008, 1, '2025-11-03 20:30:00', 1, 499.00, 'Pending');

-- OrderItems
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, PricePerUnit) VALUES
(1, 1001, 5, 2, 599.00), -- 2 T-shirts
(2, 1001, 10, 2, 1400.00), -- 2 Chinos (on sale)
(3, 1002, 7, 1, 84999.00), -- 1 Galaxy S24
(4, 1003, 2, 1, 114900.00), -- 1 MacBook Air
(5, 1004, 3, 1, 350.00), -- 1 Silent Patient
(6, 1004, 9, 1, 450.00), -- 1 Dune
(7, 1004, 7, 1, 149.00), -- 1 bookmark (example, product not listed)
(8, 1005, 6, 1, 1999.00), -- 1 Denim Jacket
(9, 1006, 3, 1, 350.00), -- 1 Silent Patient
(10, 1007, 5, 1, 599.00), -- 1 T-Shirt
(11, 1008, 4, 1, 499.00); -- 1 Atomic Habits

-- Payments
INSERT INTO Payments (PaymentID, OrderID, PaymentDate, PaymentMethod, TransactionStatus, Amount) VALUES
(1, 1001, '2025-10-01 10:31:00', 'UPI', 'Success', 3998.00),
(2, 1002, '2025-10-03 14:16:00', 'Credit Card', 'Success', 84999.00),
(3, 1003, '2025-10-05 09:01:00', 'Credit Card', 'Success', 114900.00),
(4, 1004, '2025-10-05 17:46:00', 'COD', 'Pending', 949.00),
(5, 1004, '2025-10-08 14:00:00', 'COD', 'Success', 949.00), -- COD marked as success on delivery
(6, 1005, '2025-10-06 11:11:00', 'UPI', 'Failed', 1999.00), -- Failed payment
(7, 1006, '2025-10-07 12:01:00', 'UPI', 'Success', 350.00),
(8, 1007, '2025-11-01 10:01:00', 'Credit Card', 'Success', 599.00),
(9, 1008, '2025-11-03 20:31:00', 'UPI', 'Pending', 499.00);
