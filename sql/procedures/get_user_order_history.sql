-- Example stored procedure: Get user order history
-- This procedure returns the order history for a specific user

CREATE OR REPLACE PROCEDURE get_user_order_history(user_id_param INTEGER)
RETURNS TABLE(order_id INTEGER, total_amount DECIMAL(10,2), status VARCHAR(50), created_at TIMESTAMP_NTZ)
LANGUAGE SQL
AS
$$
DECLARE
    result_cursor CURSOR FOR 
        SELECT id, total_amount, status, created_at 
        FROM orders 
        WHERE user_id = user_id_param
        ORDER BY created_at DESC;
BEGIN
    OPEN result_cursor;
    RETURN TABLE(result_cursor);
END;
$$;