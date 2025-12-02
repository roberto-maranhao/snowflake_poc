-- Example function: Calculate order total with tax
-- This function calculates the total order amount including tax

CREATE OR REPLACE FUNCTION calculate_order_total_with_tax(base_amount DECIMAL(10,2), tax_rate DECIMAL(5,4) DEFAULT 0.0825)
RETURNS DECIMAL(10,2)
LANGUAGE SQL
AS
$$
    base_amount * (1 + tax_rate)
$$;