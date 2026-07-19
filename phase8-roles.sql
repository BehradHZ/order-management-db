-- =============================================================================
-- BASE SCHEMA PRIVILEGES
-- =============================================================================
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- =============================================================================
-- 1) ROLE: role_shop_admin
-- =============================================================================
DROP ROLE IF EXISTS role_shop_admin;
CREATE ROLE role_shop_admin;

GRANT USAGE, CREATE ON SCHEMA public TO role_shop_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_shop_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_shop_admin;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO role_shop_admin;

DROP USER IF EXISTS user_shop_admin;
CREATE USER user_shop_admin WITH PASSWORD 'Admin_P@ss1405' IN ROLE role_shop_admin;


-- =============================================================================
-- 2) ROLE: role_seller
-- =============================================================================
DROP ROLE IF EXISTS role_seller;
CREATE ROLE role_seller;

GRANT USAGE ON SCHEMA public TO role_seller;

GRANT SELECT ON Seller, Seller_Phone TO role_seller;
GRANT SELECT, INSERT, UPDATE ON Product TO role_seller;
GRANT SELECT ON Category, Product_Category TO role_seller;
GRANT INSERT, DELETE ON Product_Category TO role_seller;
GRANT SELECT, UPDATE ON Inventory_Stock TO role_seller;
GRANT SELECT ON Inventory_Location TO role_seller;
GRANT SELECT, INSERT ON Inventory_Log TO role_seller;

GRANT SELECT ON Order_Item TO role_seller;
GRANT SELECT ON "Order" TO role_seller;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_seller;

GRANT SELECT ON vw_status_sales_seller TO role_seller;
GRANT SELECT ON vw_recent_orders_30days TO role_seller;
GRANT SELECT ON vw_alerts_inventory TO role_seller;

REVOKE ALL PRIVILEGES ON Payment FROM role_seller;
REVOKE ALL PRIVILEGES ON Customer, Customer_Phone, Customer_Address FROM role_seller;

DROP USER IF EXISTS user_seller;
CREATE USER user_seller WITH PASSWORD 'Seller_P@ss1405' IN ROLE role_seller;


-- =============================================================================
-- 3) ROLE: role_support
-- =============================================================================
DROP ROLE IF EXISTS role_support;
CREATE ROLE role_support;

GRANT USAGE ON SCHEMA public TO role_support;

GRANT SELECT ON Customer, Customer_Phone, Customer_Address TO role_support;
GRANT UPDATE (account_status) ON Customer TO role_support;

GRANT SELECT ON "Order" TO role_support;
GRANT UPDATE (order_status) ON "Order" TO role_support;
GRANT SELECT ON Order_Item TO role_support;

GRANT SELECT ON Payment TO role_support;
GRANT UPDATE (payment_status) ON Payment TO role_support;

GRANT SELECT ON Shipment TO role_support;
GRANT SELECT ON Product, Seller TO role_support;

GRANT SELECT ON vw_summary_orders_customer TO role_support;
GRANT SELECT ON vw_recent_orders_30days TO role_support;

GRANT EXECUTE ON PROCEDURE pr_cancel_order(INT, VARCHAR) TO role_support;

DROP USER IF EXISTS user_support;
CREATE USER user_support WITH PASSWORD 'Support_P@ss1405' IN ROLE role_support;


-- =============================================================================
-- 4) ROLE: role_warehouse
-- =============================================================================
DROP ROLE IF EXISTS role_warehouse;
CREATE ROLE role_warehouse;

GRANT USAGE ON SCHEMA public TO role_warehouse;

GRANT SELECT ON "Order", Order_Item TO role_warehouse;

GRANT SELECT, UPDATE ON Inventory_Stock TO role_warehouse;
GRANT SELECT, INSERT, UPDATE, DELETE ON Inventory_Location TO role_warehouse;
GRANT SELECT, INSERT ON Inventory_Log TO role_warehouse;

GRANT SELECT, INSERT, UPDATE ON Shipment TO role_warehouse;
GRANT SELECT ON Product TO role_warehouse;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_warehouse;

GRANT SELECT ON vw_alerts_inventory TO role_warehouse;

DROP USER IF EXISTS user_warehouse;
CREATE USER user_warehouse WITH PASSWORD 'Warehouse_P@ss1405' IN ROLE role_warehouse;


-- =============================================================================
-- 5) GENERAL SECURITY RESTRICTIONS (DDL & AUDIT PROTECTION)
-- =============================================================================
REVOKE TRUNCATE, TRIGGER, REFERENCES ON ALL TABLES IN SCHEMA public
    FROM role_seller, role_support, role_warehouse;