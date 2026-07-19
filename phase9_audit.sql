-- =============================================================================
-- 1) Audit_Log Table
-- =============================================================================
CREATE TABLE Audit_Log (
    log_id          INT GENERATED ALWAYS AS IDENTITY,
    table_name      VARCHAR(50)  NOT NULL,
    operation_type  VARCHAR(10)  NOT NULL,
    record_id       VARCHAR(100) NOT NULL,
    old_data        JSONB,
    new_data        JSONB,
    changed_by      VARCHAR(100) NOT NULL DEFAULT CURRENT_USER,
    changed_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_Audit_Log PRIMARY KEY (log_id),
    CONSTRAINT CHK_Audit_Log_Operation CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE INDEX IDX_Audit_Log_Table_Time ON Audit_Log (table_name, changed_at DESC);
CREATE INDEX IDX_Audit_Log_Record ON Audit_Log (table_name, record_id);


-- =============================================================================
-- 2) Generic Trigger Function for Audit
-- =============================================================================
CREATE OR REPLACE FUNCTION fn_audit_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_record_id  TEXT;
    v_pk_columns TEXT[];
    v_col        TEXT;
    v_parts      TEXT[] := ARRAY[]::TEXT[];
BEGIN
    SELECT array_agg(a.attname ORDER BY a.attnum)
    INTO v_pk_columns
    FROM pg_index i
    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
    WHERE i.indrelid = TG_RELID
      AND i.indisprimary;

    IF TG_OP = 'DELETE' THEN
        FOREACH v_col IN ARRAY v_pk_columns LOOP
            v_parts := v_parts || (to_jsonb(OLD) ->> v_col);
        END LOOP;
        v_record_id := array_to_string(v_parts, '|');

        INSERT INTO Audit_Log (table_name, operation_type, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), NULL, CURRENT_USER);

        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN
        FOREACH v_col IN ARRAY v_pk_columns LOOP
            v_parts := v_parts || (to_jsonb(NEW) ->> v_col);
        END LOOP;
        v_record_id := array_to_string(v_parts, '|');

        INSERT INTO Audit_Log (table_name, operation_type, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), to_jsonb(NEW), CURRENT_USER);

        RETURN NEW;

    ELSIF TG_OP = 'INSERT' THEN
        FOREACH v_col IN ARRAY v_pk_columns LOOP
            v_parts := v_parts || (to_jsonb(NEW) ->> v_col);
        END LOOP;
        v_record_id := array_to_string(v_parts, '|');

        INSERT INTO Audit_Log (table_name, operation_type, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, NULL, to_jsonb(NEW), CURRENT_USER);

        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$;


-- =============================================================================
-- 3) Defining Triggers on Main Tables
-- =============================================================================

-- ---------------------------------------------------------------------
-- 3.1) Product Table Triggers
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_audit_product
AFTER INSERT OR UPDATE OR DELETE ON Product
FOR EACH ROW
EXECUTE FUNCTION fn_audit_trigger();

-- ---------------------------------------------------------------------
-- 3.2) Order Table Triggers
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_audit_order
AFTER INSERT OR UPDATE OR DELETE ON "Order"
FOR EACH ROW
EXECUTE FUNCTION fn_audit_trigger();

-- ---------------------------------------------------------------------
-- 3.3) Inventory_Stock Table Triggers
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_audit_inventory_stock
AFTER INSERT OR UPDATE OR DELETE ON Inventory_Stock
FOR EACH ROW
EXECUTE FUNCTION fn_audit_trigger();

-- ---------------------------------------------------------------------
-- 3.4) Payment Table Triggers
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_audit_payment
AFTER INSERT OR UPDATE OR DELETE ON Payment
FOR EACH ROW
EXECUTE FUNCTION fn_audit_trigger();


-- =============================================================================
-- 4) Views for Audit_Log Reporting
-- =============================================================================

-- ---------------------------------------------------------------------
-- 4.1) vw_audit_recent_order_changes
-- ---------------------------------------------------------------------
CREATE VIEW vw_audit_recent_order_changes AS
SELECT
    log_id,
    operation_type,
    record_id                              AS order_id,
    old_data ->> 'order_status'            AS old_status,
    new_data ->> 'order_status'            AS new_status,
    old_data ->> 'total_amount'            AS old_total_amount,
    new_data ->> 'total_amount'            AS new_total_amount,
    changed_by,
    changed_at
FROM Audit_Log
WHERE table_name = 'Order'
ORDER BY changed_at DESC;

-- ---------------------------------------------------------------------
-- 4.2) vw_audit_product_price_history
-- ---------------------------------------------------------------------
CREATE VIEW vw_audit_product_price_history AS
SELECT
    log_id,
    operation_type,
    record_id                       AS product_id,
    old_data ->> 'name'             AS product_name,
    old_data ->> 'price'            AS old_price,
    new_data ->> 'price'            AS new_price,
    changed_by,
    changed_at
FROM Audit_Log
WHERE table_name = 'product'
  AND (
        operation_type = 'INSERT'
        OR (operation_type = 'UPDATE' AND (old_data ->> 'price') IS DISTINCT FROM (new_data ->> 'price'))
        OR operation_type = 'DELETE'
      )
ORDER BY changed_at DESC;

-- ---------------------------------------------------------------------
-- 4.3) vw_audit_inventory_changes
-- ---------------------------------------------------------------------
CREATE VIEW vw_audit_inventory_changes AS
SELECT
    log_id,
    operation_type,
    record_id                            AS product_id,
    old_data ->> 'stock_quantity'        AS old_stock_quantity,
    new_data ->> 'stock_quantity'        AS new_stock_quantity,
    changed_by,
    changed_at
FROM Audit_Log
WHERE table_name = 'inventory_stock'
ORDER BY changed_at DESC;

-- ---------------------------------------------------------------------
-- 4.4) vw_audit_payment_status_changes
-- ---------------------------------------------------------------------
CREATE VIEW vw_audit_payment_status_changes AS
SELECT
    log_id,
    operation_type,
    record_id                          AS payment_id,
    old_data ->> 'payment_status'      AS old_status,
    new_data ->> 'payment_status'      AS new_status,
    changed_by,
    changed_at
FROM Audit_Log
WHERE table_name = 'payment'
ORDER BY changed_at DESC;


-- =============================================================================
-- 5) Tests
-- =============================================================================

-- ---------------------------------------------------------------------
-- 5.1) INSERT Test on Product
-- ---------------------------------------------------------------------
INSERT INTO Product (name, description, price, is_active, dimensions, weight, seller_id)
VALUES ('Wireless Mouse', 'Ergonomic wireless mouse', 22.50, TRUE, '10x6x3 cm', 0.090, 1);

SELECT * FROM Audit_Log
WHERE table_name = 'product' AND operation_type = 'INSERT'
ORDER BY changed_at DESC
LIMIT 1;


-- ---------------------------------------------------------------------
-- 5.2) UPDATE Test on Product (Price Change)
-- ---------------------------------------------------------------------
UPDATE Product
SET price = 27.00
WHERE product_id = (SELECT product_id FROM Product WHERE name = 'Wireless Mouse');

SELECT * FROM vw_audit_product_price_history
WHERE product_name = 'Wireless Mouse';


-- ---------------------------------------------------------------------
-- 5.4) UPDATE Test on Inventory_Stock (Decrease Quantity)
-- ---------------------------------------------------------------------
UPDATE Inventory_Stock
SET stock_quantity = stock_quantity - 1,
    last_update_date = CURRENT_TIMESTAMP
WHERE product_id = 6;

SELECT * FROM vw_audit_inventory_changes
WHERE product_id = '6';


-- ---------------------------------------------------------------------
-- 5.5) UPDATE Test on Payment (Status Change)
-- ---------------------------------------------------------------------
UPDATE Payment
SET payment_status = 'Refunded'
WHERE payment_id = 7;

SELECT * FROM vw_audit_payment_status_changes
WHERE payment_id = '7';


-- ---------------------------------------------------------------------
-- 5.6) DELETE Test on Product
-- ---------------------------------------------------------------------
DELETE FROM Product
WHERE name = 'Wireless Mouse';

SELECT * FROM Audit_Log
WHERE table_name = 'product' AND operation_type = 'DELETE'
ORDER BY changed_at DESC
LIMIT 1;


-- ---------------------------------------------------------------------
-- 5.7) Final Review of Recent Log Events
-- ---------------------------------------------------------------------
SELECT
    log_id,
    table_name,
    operation_type,
    record_id,
    changed_by,
    changed_at
FROM Audit_Log
ORDER BY changed_at DESC
LIMIT 20;