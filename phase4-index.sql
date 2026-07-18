-- ایندکس ۱: Order(customer_id, order_date DESC)
CREATE INDEX IDX_Order_Customer_Date ON "Order" (customer_id, order_date DESC);

-- ایندکس ۲: Order(order_date) — پشتیبانی از کوئری‌های بازه‌ زمانی گزارش‌گیری کلی
CREATE INDEX IDX_Order_Date ON "Order" (order_date);

-- ایندکس ۳: Payment(payment_status)
CREATE INDEX IDX_Payment_Status ON Payment (payment_status);

-- ایندکس ۴: Inventory_Stock(product_id) WHERE stock_quantity < alert_threshold  (Partial Index)
CREATE INDEX IDX_Inventory_LowStock ON Inventory_Stock (product_id)
    WHERE stock_quantity < alert_threshold;

-- ایندکس ۵ (ترکیبی): Order_Item(product_id, order_id)
CREATE INDEX IDX_OrderItem_Product_Order ON Order_Item (product_id, order_id);