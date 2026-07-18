INSERT INTO Customer (first_name, last_name, email, registration_date, account_status) VALUES
('Ali', 'Ahmadi', 'ali.ahmadi@email.com', '2026-01-10 10:00:00', 'Active'),
('Sara', 'Karimi', 'sara.karimi@email.com', '2026-02-15 11:30:00', 'Active'),
('Reza', 'Mohammadi', 'reza.mohammadi@email.com', '2026-03-01 09:15:00', 'Active'),
('Maryam', 'Zare', 'maryam.zare@email.com', '2026-03-20 14:45:00', 'Suspended'),
('Mohammad', 'Hosseini', 'm.hosseini@email.com', '2026-04-05 16:20:00', 'Active'),
('Zahra', 'Rezaei', 'zahra.rezaei@email.com', '2026-05-12 08:00:00', 'Active'),
('Mehdi', 'Nazari', 'mehdi.nazari@email.com', '2026-06-01 19:10:00', 'Inactive'),
('Neda', 'Ghasemi', 'neda.ghasemi@email.com', '2026-06-15 12:00:00', 'Active'),
('Arman', 'Tavahodi', 'arman.tava@email.com', '2026-07-01 15:30:00', 'Active'),
('Elham', 'Salehi', 'elham.salehi@email.com', '2026-07-10 17:40:00', 'Active');

INSERT INTO Postal_Code (postal_code, state, city) VALUES
('1417466111', 'Tehran', 'Tehran'),
('1417466112', 'Tehran', 'Tehran'),
('8134567890', 'Isfahan', 'Isfahan'),
('8134567891', 'Isfahan', 'Isfahan'),
('9177543210', 'Razavi Khorasan', 'Mashhad'),
('7134512345', 'Fars', 'Shiraz'),
('5133598765', 'East Azerbaijan', 'Tabriz'),
('3153511111', 'Alborz', 'Karaj'),
('3513522222', 'Semnan', 'Semnan'),
('4133533333', 'Gilan', 'Rasht');

INSERT INTO Seller (brand_name, email, approval_status, membership_date) VALUES
('DigiTech', 'info@digitech.com', 'Approved', '2026-01-01 08:00:00'),
('StyleMode', 'sales@stylemode.com', 'Approved', '2026-01-15 09:30:00'),
('BookLand', 'contact@bookland.com', 'Approved', '2026-02-01 10:00:00'),
('HomeApp', 'support@homeapp.com', 'Approved', '2026-02-20 11:15:00'),
('SportMax', 'sportmax@email.com', 'Pending', '2026-07-12 14:00:00'),
('BeautyZone', 'beauty@zone.com', 'Approved', '2026-03-05 15:30:00'),
('GreenGrocer', 'green@grocer.com', 'Suspended', '2026-03-18 16:45:00'),
('ToyStory', 'toys@story.com', 'Approved', '2026-04-01 09:00:00'),
('HyperMarket', 'hyper@market.com', 'Approved', '2026-04-25 10:30:00'),
('ElectroWorld', 'world@electro.com', 'Rejected', '2026-07-05 11:00:00');

INSERT INTO Category (category_name, parent_category_id) VALUES
('Electronics', NULL),       -- 1
('Clothing', NULL),          -- 2
('Books', NULL),             -- 3
('Home & Kitchen', NULL),     -- 4
('Smartphones', 1),          -- 5 (Parent: Electronics)
('Laptops', 1),              -- 6 (Parent: Electronics)
('Men Clothes', 2),          -- 7 (Parent: Clothing)
('Women Clothes', 2),        -- 8 (Parent: Clothing)
('Novels', 3),               -- 9 (Parent: Books)
('Appliances', 4);           -- 10 (Parent: Home & Kitchen)

INSERT INTO Promo_Code (promo_code, start_date, end_date, usage_limit, min_order_amount) VALUES
('WELCOME10', '2026-01-01', '2026-12-31', 100, 50.00),
('SUMMER20', '2026-06-01', '2026-08-31', 50, 200.00),
('FLAT50', '2026-03-01', '2026-04-30', 30, 150.00),
('YALDA1405', '2026-12-15', '2026-12-25', 200, 100.00),
('EID2026', '2026-03-15', '2026-04-05', 500, 0.00),
('TECHBONUS', '2026-05-01', '2026-05-31', 20, 500.00),
('BOOKS5', '2026-02-01', '2026-08-01', 1000, 20.00),
('WEEKEND15', '2026-07-01', '2026-07-31', 80, 80.00),
('MIDYEAR', '2026-06-15', '2026-07-15', 40, 300.00),
('BLACKFRIDAY', '2026-11-20', '2026-11-30', 100, 100.00);

INSERT INTO Percentage_Discount (promo_code, discount_percentage, max_discount_amount) VALUES
('WELCOME10', 10.00, 30.00),
('SUMMER20', 20.00, 100.00),
('EID2026', 15.00, 50.00),
('TECHBONUS', 5.00, 200.00),
('WEEKEND15', 15.00, 40.00);

INSERT INTO Flat_Discount (promo_code, discount_amount) VALUES
('FLAT50', 50.00),
('BOOKS5', 5.00),
('MIDYEAR', 60.00);

INSERT INTO Customer_Phone (customer_id, phone_number) VALUES
(1, '09121111111'),
(1, '02188888881'),
(2, '09132222222'),
(3, '09153333333'),
(4, '09174444444'),
(5, '09145555555'),
(6, '09356666666'),
(7, '09367777777'),
(8, '09378888888'),
(9, '09389999999'),
(10, '09390000000');

INSERT INTO Customer_Address (customer_id, postal_code, street) VALUES
(1, '1417466111', 'Hafez St, No 12'),
(1, '1417466112', 'Valiasr St, Alley 4, No 5'),
(2, '8134567890', 'Ozer St, Block 2'),
(3, '9177543210', 'Ahmadabad St, No 45'),
(4, '7134512345', 'Zand St, Alley 10'),
(5, '5133598765', 'Shahnaz St, No 88'),
(6, '3153511111', 'Gohardasht, Main St'),
(7, '3513522222', 'Ghods St, Alley 2'),
(8, '4133533333', 'Golsar, No 102'),
(9, '1417466111', 'Enghelab St, Apartment 3'),
(10, '8134567891', 'Chaharbagh St, No 17');

INSERT INTO Seller_Phone (seller_id, phone_number) VALUES
(1, '02144441111'),
(1, '02144441112'),
(2, '02144442222'),
(3, '02144443333'),
(4, '02144444444'),
(5, '02144445555'),
(6, '02144446666'),
(7, '02144447777'),
(8, '02144448888'),
(9, '02144449999'),
(10, '02144440000');

INSERT INTO Product (name, description, price, is_active, dimensions, weight, seller_id) VALUES
('iPhone 14 Pro', 'Apple smartphone 128GB', 1000.00, TRUE, '147.5x71.5x7.85 mm', 0.206, 1),
('Samsung Galaxy S23', 'Samsung smartphone 256GB', 900.00, TRUE, '146.3x70.9x7.6 mm', 0.168, 1),
('Asus ROG Strix', 'Gaming Laptop 16GB RAM', 1500.00, TRUE, '354x264x22.6 mm', 2.500, 1),
('Men Leather Jacket', 'Black genuine leather jacket', 120.00, TRUE, 'Size L', 1.200, 2),
('Women Summer Dress', 'Floral cotton dress', 45.00, TRUE, 'Size M', 0.300, 2),
('Philosophy 101', 'Introduction to modern philosophy book', 25.00, TRUE, '210x148 mm', 0.400, 3),
('Microwave Oven', '800W digital microwave', 180.00, TRUE, '450x350x300 mm', 10.500, 4),
('Running Shoes', 'Professional sport running shoes', 85.00, TRUE, 'Size 42', 0.700, 2),
('Action Figure Toy', 'Superhero collection toy', 30.00, TRUE, '20x10x5 cm', 0.250, 8),
('Organic Green Tea', '100% pure organic tea pack', 15.00, TRUE, '15x10x5 cm', 0.100, 9);

INSERT INTO Product_Category (product_id, category_id) VALUES
(1, 1), (1, 5),
(2, 1), (2, 5),
(3, 1), (3, 6),
(4, 2), (4, 7),
(5, 2), (5, 8),
(6, 3), (6, 9),
(7, 4), (7, 10),
(8, 2),
(9, 8),
(10, 4);

INSERT INTO Inventory_Stock (product_id, stock_quantity, alert_threshold, last_update_date) VALUES
(1, 15, 5, '2026-07-10 10:00:00'),
(2, 3, 5, '2026-07-11 11:00:00'),   -- Low stock trigger
(3, 8, 2, '2026-07-12 09:30:00'),
(4, 25, 10, '2026-07-13 14:00:00'),
(5, 4, 10, '2026-07-14 15:15:00'),   -- Low stock trigger
(6, 100, 20, '2026-07-15 16:45:00'),
(7, 12, 3, '2026-07-16 11:20:00'),
(8, 2, 5, '2026-07-17 13:00:00'),    -- Low stock trigger
(9, 35, 8, '2026-07-17 14:10:00'),
(10, 200, 30, '2026-07-18 08:30:00');

INSERT INTO Inventory_Location (product_id, store_id, shelf, row) VALUES
(1, 'WH-MAIN', 'A1', 'R1'),
(2, 'WH-MAIN', 'A1', 'R2'),
(3, 'WH-MAIN', 'A2', 'R1'),
(4, 'WH-CLOTH', 'B1', 'R1'),
(5, 'WH-CLOTH', 'B1', 'R2'),
(6, 'WH-BOOKS', 'C1', 'R1'),
(7, 'WH-MAIN', 'A3', 'R1'),
(8, 'WH-CLOTH', 'B2', 'R1'),
(9, 'WH-TOYS', 'D1', 'R1'),
(10, 'WH-MAIN', 'A4', 'R1');

INSERT INTO Inventory_Log (product_id, store_id, shelf, row, change_type, quantity_changed, reason) VALUES
(1, 'WH-MAIN', 'A1', 'R1', 'Restock', 20, 'Initial supplier delivery'),
(1, 'WH-MAIN', 'A1', 'R1', 'Sale', 5, 'Orders fulfillment'),
(2, 'WH-MAIN', 'A1', 'R2', 'Restock', 5, 'Supplier delivery'),
(3, 'WH-MAIN', 'A2', 'R1', 'Restock', 10, 'New items'),
(4, 'WH-CLOTH', 'B1', 'R1', 'Restock', 30, 'Bulk delivery'),
(4, 'WH-CLOTH', 'B1', 'R1', 'Return', 3, 'Customer returned wrong size'),
(5, 'WH-CLOTH', 'B1', 'R2', 'Damage', 2, 'Water damage in storage'),
(6, 'WH-BOOKS', 'C1', 'R1', 'Restock', 100, 'Publisher delivery'),
(7, 'WH-MAIN', 'A3', 'R1', 'Restock', 15, 'Restock arrival'),
(8, 'WH-CLOTH', 'B2', 'R1', 'Sale', 3, 'Customer orders'),
(9, 'WH-TOYS', 'D1', 'R1', 'Restock', 40, 'Initial stock for launch'),
(9, 'WH-TOYS', 'D1', 'R1', 'Sale', 5, 'Order #9 fulfillment'),
(10, 'WH-MAIN', 'A4', 'R1', 'Restock', 200, 'Seasonal replenishment');

INSERT INTO "Order" (order_status, order_date, total_amount, shipping_cost, discount, customer_id, customer_postal_code, promo_code) VALUES
('Delivered', '2026-06-10 14:30:00', 1015.00, 15.00, 0.00, 1, '1417466111', NULL),
('Delivered', '2026-07-02 10:00:00', 915.00, 15.00, 0.00, 1, '1417466112', NULL),
('Shipped', '2026-07-12 11:15:00', 1000.00, 20.00, 20.00, 1, '1417466111', 'WELCOME10'),
('Processing', '2026-07-15 16:00:00', 1500.00, 0.00, 0.00, 1, '1417466111', NULL),
('Pending', '2026-07-18 09:00:00', 45.00, 10.00, 10.00, 1, '1417466112', 'WELCOME10'), -- 5th order for customer 1
('Pending', '2026-07-18 10:15:00', 135.00, 15.00, 0.00, 1, '1417466111', NULL),        -- 6th order for customer 1 (testing 5 recent)
('Delivered', '2026-07-05 12:00:00', 25.00, 10.00, 10.00, 2, '8134567890', 'WELCOME10'),
('Cancelled', '2026-07-10 14:20:00', 195.00, 15.00, 0.00, 3, '9177543210', NULL),
('Processing', '2026-07-16 08:45:00', 220.00, 15.00, 50.00, 5, '5133598765', 'FLAT50'),
('Delivered', '2026-07-14 17:30:00', 40.00, 10.00, 0.00, 6, '3153511111', NULL),
('Delivered', '2026-06-20 13:00:00', 95.00, 10.00, 0.00, 8, '4133533333', NULL);
INSERT INTO Order_Item (order_id, item_number, quantity, unit_price, product_id) VALUES
(1, 1, 1, 1000.00, 1),
(2, 1, 1, 900.00, 2),
(3, 1, 1, 1000.00, 1),
(4, 1, 1, 1500.00, 3),
(5, 1, 1, 45.00, 5),
(6, 1, 1, 120.00, 4),
(7, 1, 1, 25.00, 6),
(8, 1, 1, 180.00, 7),
(9, 1, 1, 180.00, 7),
(9, 2, 5, 15.00, 10),
(10, 1, 1, 30.00, 9),
(11, 1, 1, 85.00, 8);

INSERT INTO Payment (amount, payment_method, payment_status, payment_time, tracking_code, order_id) VALUES
(1015.00, 'Credit Card', 'Successful', '2026-06-10 14:35:00', 'TRK-111111', 1),
(915.00, 'Credit Card', 'Successful', '2026-07-02 10:05:00', 'TRK-222222', 2),
(1000.00, 'Online Banking', 'Successful', '2026-07-12 11:20:00', 'TRK-333333', 3),
(1500.00, 'Credit Card', 'Successful', '2026-07-15 16:02:00', 'TRK-444444', 4),
(45.00, 'Credit Card', 'Pending', '2026-07-18 09:00:00', NULL, 5),          -- Pending payment
(135.00, 'Online Banking', 'Failed', '2026-07-18 10:16:00', 'TRK-666666', 6), -- Failed payment
(25.00, 'Wallet', 'Successful', '2026-07-05 12:02:00', 'TRK-777777', 7),
(195.00, 'Credit Card', 'Failed', '2026-07-10 14:21:00', NULL, 8),
(220.00, 'Credit Card', 'Successful', '2026-07-16 08:50:00', 'TRK-999999', 9),
(40.00, 'Wallet', 'Successful', '2026-07-14 17:35:00', 'TRK-000000', 10),
(95.00, 'Credit Card', 'Refunded', '2026-06-21 09:00:00', 'TRK-REFUND01', 11);

INSERT INTO Shipment (shipment_tracking_code, time, status, order_id) VALUES
('POST-AAA111', '2026-06-11 09:00:00', 'Delivered', 1),
('POST-BBB222', '2026-07-03 10:00:00', 'Delivered', 2),
('POST-CCC333', '2026-07-13 08:30:00', 'Handed_To_Carrier', 3),
('POST-DDD444', '2026-07-06 14:00:00', 'Delivered', 7),
('POST-EEE555', '2026-07-15 11:00:00', 'Returned', 8),
('POST-FFF666', '2026-07-15 19:00:00', 'Delivered', 10),
('POST-GGG777', '2026-07-18 11:30:00', 'Preparing', 11);

------------------------------------------------------------------------------------

-- پرس و جوی یکم
-- نمایش اطلاعات تمام سفارش های متعلق به یک مشتری مشخص

SELECT 
    order_id, 
    order_status, 
    order_date, 
    total_amount, 
    shipping_cost, 
    discount, 
    customer_postal_code, 
    promo_code
FROM "Order"
WHERE customer_id = 1
ORDER BY order_date DESC;

-- پرس و جوی دوم
-- نمایش ۵ سفارش اخیر یک مشتری بر اساس تاریخ ثبت سفارش

SELECT 
    order_id, 
    order_status, 
    order_date, 
    total_amount
FROM "Order"
WHERE customer_id = 1
ORDER BY order_date DESC
LIMIT 5;

-- پرس و جوی سوم
-- نمایش محصولاتی که موجودی آن‌ها کمتر از حد هشدار تعریف شده است

SELECT 
    p.product_id, 
    p.name AS product_name, 
    i.stock_quantity, 
    i.alert_threshold,
    s.brand_name AS seller_brand
FROM Product p
JOIN Inventory_Stock i ON p.product_id = i.product_id
JOIN Seller s ON p.seller_id = s.seller_id
WHERE i.stock_quantity < i.alert_threshold;

-- پرس و جوی چهارم
-- نمایش فروشندگانی که در ماه اخیر بیش از یک مقدار مشخص فروش داشته اند

SELECT 
    s.seller_id, 
    s.brand_name, 
    s.email,
    SUM(oi.quantity * oi.unit_price) AS total_sales_amount
FROM Seller s
JOIN Product p ON s.seller_id = p.seller_id
JOIN Order_Item oi ON p.product_id = oi.product_id
JOIN "Order" o ON oi.order_id = o.order_id
WHERE o.order_date >= NOW() - INTERVAL '30 days'
  AND o.order_status IN ('Processing', 'Shipped', 'Delivered') -- در نظر گرفتن سفارشات معتبر و نهایی شده
GROUP BY s.seller_id, s.brand_name, s.email
HAVING SUM(oi.quantity * oi.unit_price) > 500.00;

-- پرس و جوی پنجم
-- نمایش سفارش هایی که پرداخت ناموفق یا در انتظار پرداخت دارند

SELECT DISTINCT
    o.order_id, 
    o.order_status, 
    o.order_date, 
    o.total_amount, 
    o.customer_id,
    p.payment_status,
    p.payment_method
FROM "Order" o
JOIN Payment p ON o.order_id = p.order_id
WHERE p.payment_status IN ('Failed', 'Pending')
ORDER BY o.order_date DESC;

-- پرس و جوی ششم
-- نمایش تعداد سفارش های انجام شده در یک بازه زمانی مشخص (یک هفته گذشته)

SELECT 
    COUNT(order_id) AS total_orders_count,
    COALESCE(SUM(total_amount), 0) AS total_revenue
FROM "Order"
WHERE order_date >= NOW() - INTERVAL '7 days'
  AND order_status != 'Cancelled';