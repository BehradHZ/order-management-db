-- =============================================================================
-- 1) Place New Order - pr_place_order
-- =============================================================================

CREATE OR REPLACE PROCEDURE pr_place_order(
    IN  p_customer_id    INT,
    IN  p_postal_code    VARCHAR(10),
    IN  p_shipping_cost  DECIMAL(10,2),
    IN  p_promo_code     VARCHAR(50),
    IN  p_items          JSONB,
    OUT p_order_id       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_status     VARCHAR(20);
    v_address_exists      BOOLEAN;
    v_item                JSONB;
    v_product_id          INT;
    v_quantity            INT;
    v_unit_price          DECIMAL(12,2);
    v_is_active           BOOLEAN;
    v_stock_quantity      INT;
    v_items_count         INT;
    v_item_number         INT := 0;
    v_subtotal            DECIMAL(12,2) := 0;
    v_discount_amount     DECIMAL(12,2) := 0;
    v_total_amount        DECIMAL(12,2);
    v_promo_start         DATE;
    v_promo_end           DATE;
    v_promo_min_amount    DECIMAL(12,2);
    v_pct_discount        DECIMAL(5,2);
    v_pct_max_discount    DECIMAL(12,2);
    v_flat_discount       DECIMAL(12,2);
BEGIN
    SELECT account_status INTO v_customer_status
    FROM Customer
    WHERE customer_id = p_customer_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer with ID % not found', p_customer_id;
    END IF;

    IF v_customer_status <> 'Active' THEN
        RAISE EXCEPTION 'Customer with ID % is not active (current status: %)', p_customer_id, v_customer_status;
    END IF;

    SELECT EXISTS (
        SELECT 1 FROM Customer_Address
        WHERE customer_id = p_customer_id
          AND postal_code = p_postal_code
    ) INTO v_address_exists;

    IF NOT v_address_exists THEN
        RAISE EXCEPTION 'Address with postal code % is not registered for customer %', p_postal_code, p_customer_id;
    END IF;

    IF p_items IS NULL OR jsonb_array_length(p_items) = 0 THEN
        RAISE EXCEPTION 'Order items list cannot be empty';
    END IF;

    INSERT INTO "Order" (
        order_status, order_date, total_amount, shipping_cost,
        discount, customer_id, customer_postal_code, promo_code
    ) VALUES (
        'Pending', CURRENT_TIMESTAMP, 0, COALESCE(p_shipping_cost, 0),
        0, p_customer_id, p_postal_code, NULL
    )
    RETURNING order_id INTO p_order_id;

    v_items_count := jsonb_array_length(p_items);

    FOR i IN 0 .. v_items_count - 1 LOOP
        v_item := p_items -> i;

        v_product_id := (v_item ->> 'product_id')::INT;
        v_quantity   := (v_item ->> 'quantity')::INT;

        IF v_product_id IS NULL THEN
            RAISE EXCEPTION 'Product ID is missing in item number %', i + 1;
        END IF;

        IF v_quantity IS NULL OR v_quantity <= 0 THEN
            RAISE EXCEPTION 'Invalid quantity for product % (must be greater than zero)', v_product_id;
        END IF;

        SELECT price, is_active INTO v_unit_price, v_is_active
        FROM Product
        WHERE product_id = v_product_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Product with ID % not found', v_product_id;
        END IF;

        IF NOT v_is_active THEN
            RAISE EXCEPTION 'Product with ID % is inactive and cannot be ordered', v_product_id;
        END IF;

        SELECT stock_quantity INTO v_stock_quantity
        FROM Inventory_Stock
        WHERE product_id = v_product_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Inventory stock record for product % not found', v_product_id;
        END IF;

        IF v_stock_quantity < v_quantity THEN
            RAISE EXCEPTION 'Insufficient stock for product % (available: %, requested: %)',
                v_product_id, v_stock_quantity, v_quantity;
        END IF;

        v_item_number := v_item_number + 1;

        INSERT INTO Order_Item (order_id, item_number, quantity, unit_price, product_id)
        VALUES (p_order_id, v_item_number, v_quantity, v_unit_price, v_product_id);

        UPDATE Inventory_Stock
        SET stock_quantity = stock_quantity - v_quantity,
            last_update_date = CURRENT_TIMESTAMP
        WHERE product_id = v_product_id;

        v_subtotal := v_subtotal + (v_unit_price * v_quantity);
    END LOOP;

    IF p_promo_code IS NOT NULL THEN
        SELECT start_date, end_date, min_order_amount
        INTO v_promo_start, v_promo_end, v_promo_min_amount
        FROM Promo_Code
        WHERE promo_code = p_promo_code;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Promo code % not found', p_promo_code;
        END IF;

        IF CURRENT_DATE < v_promo_start OR CURRENT_DATE > v_promo_end THEN
            RAISE EXCEPTION 'Promo code % is not valid (validity period: % to %)',
                p_promo_code, v_promo_start, v_promo_end;
        END IF;

        IF v_subtotal < v_promo_min_amount THEN
            RAISE EXCEPTION 'Order amount (%) is less than the minimum required amount (%) for promo code %',
                v_subtotal, v_promo_min_amount, p_promo_code;
        END IF;

        SELECT discount_percentage, max_discount_amount
        INTO v_pct_discount, v_pct_max_discount
        FROM Percentage_Discount
        WHERE promo_code = p_promo_code;

        IF FOUND THEN
            v_discount_amount := v_subtotal * v_pct_discount / 100;
            IF v_pct_max_discount IS NOT NULL AND v_discount_amount > v_pct_max_discount THEN
                v_discount_amount := v_pct_max_discount;
            END IF;
        ELSE
            SELECT discount_amount INTO v_flat_discount
            FROM Flat_Discount
            WHERE promo_code = p_promo_code;

            IF FOUND THEN
                v_discount_amount := v_flat_discount;
            ELSE
                RAISE EXCEPTION 'Promo code % is missing a defined discount type (percentage/flat)', p_promo_code;
            END IF;
        END IF;

        IF v_discount_amount > v_subtotal THEN
            v_discount_amount := v_subtotal;
        END IF;
    END IF;

    v_total_amount := v_subtotal + COALESCE(p_shipping_cost, 0) - v_discount_amount;

    IF v_total_amount < 0 THEN
        v_total_amount := 0;
    END IF;

    UPDATE "Order"
    SET total_amount = v_total_amount,
        discount = v_discount_amount,
        promo_code = p_promo_code
    WHERE order_id = p_order_id;

END;
$$;


-- =============================================================================
-- 2) Register Order Payment - pr_register_payment
-- =============================================================================

CREATE OR REPLACE PROCEDURE pr_register_payment(
    IN  p_order_id        INT,
    IN  p_amount          DECIMAL(12,2),
    IN  p_payment_method  VARCHAR(30),
    IN  p_tracking_code   VARCHAR(100),
    OUT p_payment_id      INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_status   VARCHAR(20);
    v_total_amount   DECIMAL(12,2);
    v_already_paid   BOOLEAN;
BEGIN
    SELECT order_status, total_amount INTO v_order_status, v_total_amount
    FROM "Order"
    WHERE order_id = p_order_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order with ID % not found', p_order_id;
    END IF;

    IF v_order_status = 'Cancelled' THEN
        RAISE EXCEPTION 'Order % has been cancelled; cannot register a payment for it', p_order_id;
    END IF;

    SELECT EXISTS (
        SELECT 1 FROM Payment
        WHERE order_id = p_order_id
          AND payment_status = 'Successful'
    ) INTO v_already_paid;

    IF v_already_paid THEN
        RAISE EXCEPTION 'Order % has already been successfully paid', p_order_id;
    END IF;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Invalid payment amount (must be greater than zero)';
    END IF;

    IF p_amount <> v_total_amount THEN
        RAISE EXCEPTION 'Payment amount (%) does not match the final order amount (%)', p_amount, v_total_amount;
    END IF;

    INSERT INTO Payment (
        amount, payment_method, payment_status, payment_time, tracking_code, order_id
    ) VALUES (
        p_amount, p_payment_method, 'Successful', CURRENT_TIMESTAMP, p_tracking_code, p_order_id
    )
    RETURNING payment_id INTO p_payment_id;

    UPDATE "Order"
    SET order_status = 'Processing'
    WHERE order_id = p_order_id
      AND order_status = 'Pending';

END;
$$;


-- =============================================================================
-- 3) Cancel Order - pr_cancel_order
-- =============================================================================

CREATE OR REPLACE PROCEDURE pr_cancel_order(
    IN p_order_id      INT,
    IN p_cancel_reason  VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_status  VARCHAR(20);
    v_item          RECORD;
BEGIN
    IF p_cancel_reason IS NULL OR TRIM(p_cancel_reason) = '' THEN
        RAISE EXCEPTION 'The reason for order cancellation must be specified';
    END IF;

    SELECT order_status INTO v_order_status
    FROM "Order"
    WHERE order_id = p_order_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Order with ID % not found', p_order_id;
    END IF;

    IF v_order_status = 'Cancelled' THEN
        RAISE EXCEPTION 'Order % has already been cancelled', p_order_id;
    END IF;

    IF v_order_status IN ('Shipped', 'Delivered') THEN
        RAISE EXCEPTION 'Order % is currently % and cannot be cancelled', p_order_id, v_order_status;
    END IF;

    IF v_order_status NOT IN ('Pending', 'Processing') THEN
        RAISE EXCEPTION 'Order % cannot be cancelled in its current status: %', p_order_id, v_order_status;
    END IF;

    FOR v_item IN
        SELECT product_id, quantity
        FROM Order_Item
        WHERE order_id = p_order_id
    LOOP
        UPDATE Inventory_Stock
        SET stock_quantity = stock_quantity + v_item.quantity,
            last_update_date = CURRENT_TIMESTAMP
        WHERE product_id = v_item.product_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Inventory stock record for product % not found', v_item.product_id;
        END IF;
    END LOOP;

    UPDATE Payment
    SET payment_status = 'Refunded'
    WHERE order_id = p_order_id
      AND payment_status = 'Successful';

    UPDATE "Order"
    SET order_status = 'Cancelled'
    WHERE order_id = p_order_id;

    RAISE NOTICE 'Order % was successfully cancelled. Reason: %', p_order_id, p_cancel_reason;

END;
$$;