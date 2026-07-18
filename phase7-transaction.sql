-- ==========================================================================
-- 1) New Order Transaction - tr_place_order
-- ==========================================================================

-----------------------------------------------------------------------------
--    tr_place_order | Successful Case
--    Registering a new order for active Customer 2 (Sara Karimi) with a valid address,
--    sufficient stock for product 6 and product 10, without any promo code.
-----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_order_id INT;
BEGIN
    CALL pr_place_order(
        p_customer_id   => 2,
        p_postal_code   => '8134567890',
        p_shipping_cost => 12.00,
        p_promo_code    => NULL,
        p_items         => '[{"product_id": 6, "quantity": 2}, {"product_id": 10, "quantity": 3}]'::JSONB,
        p_order_id      => v_order_id
    );

    RAISE NOTICE 'SUCCESS: New order registered with ID %', v_order_id;
END $$;

COMMIT;

-- -----------------------------------------------------------------------------
-- tr_place_order | Failure Case (1) - Insufficient Stock
-- Product 8 (Running Shoes) has low stock. Requesting 50 units will trigger an
-- exception and the entire transaction will be rolled back.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_order_id INT;
BEGIN
    CALL pr_place_order(
        p_customer_id   => 2,
        p_postal_code   => '8134567890',
        p_shipping_cost => 10.00,
        p_promo_code    => NULL,
        p_items         => '[{"product_id": 8, "quantity": 50}]'::JSONB,
        p_order_id      => v_order_id
    );

    RAISE NOTICE 'SUCCESS: New order registered with ID %', v_order_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in placing order: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;


-- -----------------------------------------------------------------------------
-- tr_place_order | Failure Case (2) - Invalid Product ID
-- Product ID 999 does not exist. The procedure will fail and all partial changes
-- will be reverted.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_order_id INT;
BEGIN
    CALL pr_place_order(
        p_customer_id   => 2,
        p_postal_code   => '8134567890',
        p_shipping_cost => 10.00,
        p_promo_code    => NULL,
        p_items         => '[{"product_id": 999, "quantity": 1}]'::JSONB,
        p_order_id      => v_order_id
    );

    RAISE NOTICE 'SUCCESS: New order registered with ID %', v_order_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in placing order: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;


-- =============================================================================
-- 2) Order Payment Transaction - tr_payment_order
-- =============================================================================

-- -----------------------------------------------------------------------------
-- tr_payment_order | Successful Case
-- Registering a successful payment for Order 5 which is 'Pending' and has a total
-- amount of 45.00. The payment amount matches exactly.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_payment_id INT;
BEGIN
    CALL pr_register_payment(
        p_order_id       => 5,
        p_amount         => 45.00,
        p_payment_method => 'Credit Card',
        p_tracking_code  => 'TRK-555555',
        p_payment_id     => v_payment_id
    );

    RAISE NOTICE 'SUCCESS: Payment registered with ID %', v_payment_id;
END $$;

COMMIT;

-- -----------------------------------------------------------------------------
-- tr_payment_order | Failure Case (1) - Invalid Payment Amount (Negative)
-- The payment amount is negative, which violates the verification logic.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_payment_id INT;
BEGIN
    CALL pr_register_payment(
        p_order_id       => 6,
        p_amount         => -50.00,
        p_payment_method => 'Wallet',
        p_tracking_code  => 'TRK-INVALID1',
        p_payment_id     => v_payment_id
    );

    RAISE NOTICE 'SUCCESS: Payment registered with ID %', v_payment_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in registering payment: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;

-- -----------------------------------------------------------------------------
-- tr_payment_order | Failure Case (2) - Invalid Order Status (Cancelled Order)
-- Order 8 is already 'Cancelled'; trying to pay for it triggers an exception.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
DECLARE
    v_payment_id INT;
BEGIN
    CALL pr_register_payment(
        p_order_id       => 8,
        p_amount         => 195.00,
        p_payment_method => 'Credit Card',
        p_tracking_code  => 'TRK-INVALID2',
        p_payment_id     => v_payment_id
    );

    RAISE NOTICE 'SUCCESS: Payment registered with ID %', v_payment_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in registering payment: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;

-- =============================================================================
-- 3) Cancel Order Transaction - tr_cancel_ord
-- =============================================================================

-- -----------------------------------------------------------------------------
-- tr_cancel_ord | Successful Case
-- Cancelling Order 9 which is currently 'Processing'. The stocks will be safely
-- returned to Inventory_Stock and the transaction will commit.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
BEGIN
    CALL pr_cancel_order(
        p_order_id      => 9,
        p_cancel_reason => 'Customer requested cancellation.'
    );
    RAISE NOTICE 'SUCCESS: Order cancelled successfully.';
END $$;

COMMIT;

-- -----------------------------------------------------------------------------
-- tr_cancel_ord | Failure Case (1) - Order Already Shipped/Delivered
-- Order 3 is in 'Shipped' status. The procedure will reject cancellation,
-- ensuring the atomicity of the operation by aborting the transaction.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
BEGIN
    CALL pr_cancel_order(
        p_order_id      => 3,
        p_cancel_reason => 'Testing cancellation for shipped order.'
    );
    RAISE NOTICE 'SUCCESS: Order cancelled successfully.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in cancelling order: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;

-- -----------------------------------------------------------------------------
-- tr_cancel_ord | Failure Case (2) - Missing Cancellation Reason
-- The p_cancel_reason parameter is empty, violating the procedure constraints.
-- -----------------------------------------------------------------------------
BEGIN;

DO $$
BEGIN
    CALL pr_cancel_order(
        p_order_id      => 10,
        p_cancel_reason => ''
    );
    RAISE NOTICE 'SUCCESS: Order cancelled successfully.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in cancelling order: % — Transaction Rolling Back.', SQLERRM;
        RAISE;
END $$;

ROLLBACK;