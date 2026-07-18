-- ---------------------------------------------------------------------
-- View 1: vw_summary_orders_customer
-- ---------------------------------------------------------------------
CREATE VIEW vw_summary_orders_customer AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.account_status,
    COUNT(o.order_id)                          AS total_orders_count,
    COALESCE(SUM(o.total_amount), 0)           AS total_orders_amount,
    MAX(o.order_date)                          AS last_order_date
FROM Customer c
LEFT JOIN "Order" o
    ON o.customer_id = c.customer_id
   AND o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.account_status;


-- ---------------------------------------------------------------------
-- View 2: vw_status_sales_seller
-- ---------------------------------------------------------------------
CREATE VIEW vw_status_sales_seller AS
SELECT
    s.seller_id,
    s.brand_name,
    s.email,
    s.approval_status,
    COALESCE(active_products.active_product_count, 0) AS active_product_count,
    COALESCE(sales.successful_orders_count, 0) AS successful_orders_count,
    COALESCE(sales.total_sales_amount, 0)      AS total_sales_amount
FROM Seller s
LEFT JOIN (
    SELECT
        p.seller_id,
        COUNT(*) AS active_product_count
    FROM Product p
    WHERE p.is_active = TRUE
    GROUP BY p.seller_id
) active_products ON active_products.seller_id = s.seller_id
LEFT JOIN (
    SELECT
        p.seller_id,
        COUNT(DISTINCT o.order_id)                    AS successful_orders_count,
        SUM(oi.quantity * oi.unit_price)               AS total_sales_amount
    FROM Product p
    JOIN Order_Item oi ON oi.product_id = p.product_id
    JOIN "Order" o ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.seller_id
) sales ON sales.seller_id = s.seller_id;


-- ---------------------------------------------------------------------
-- View 3: vw_recent_orders_30days
-- ---------------------------------------------------------------------
CREATE VIEW vw_recent_orders_30days AS
SELECT
    o.order_id,
    o.order_status,
    o.order_date,
    o.customer_id,
    c.first_name,
    c.last_name,
    oi.item_number,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)  AS line_total,
    p.product_id,
    p.name                          AS product_name,
    p.seller_id,
    sl.brand_name                   AS seller_brand,
    sh.status                       AS shipment_status,
    sh.shipment_tracking_code
FROM "Order" o
JOIN Customer c ON c.customer_id = o.customer_id
JOIN Order_Item oi ON oi.order_id = o.order_id
JOIN Product p ON p.product_id = oi.product_id
JOIN Seller sl ON sl.seller_id = p.seller_id
LEFT JOIN Shipment sh ON sh.order_id = o.order_id
WHERE o.order_date >= NOW() - INTERVAL '30 days'
ORDER BY o.order_date DESC, o.order_id, oi.item_number;


-- ---------------------------------------------------------------------
-- View 4: vw_alerts_inventory
-- ---------------------------------------------------------------------
CREATE VIEW vw_alerts_inventory AS
SELECT
    p.product_id,
    p.name              AS product_name,
    p.price,
    p.is_active,
    s.seller_id,
    s.brand_name        AS seller_brand,
    i.stock_quantity,
    i.alert_threshold,
    i.last_update_date
FROM Product p
JOIN Inventory_Stock i ON i.product_id = p.product_id
JOIN Seller s ON s.seller_id = p.seller_id
WHERE i.stock_quantity < i.alert_threshold;
