# Procedure to get user order history
resource "snowflake_procedure" "get_user_order_history" {
  database = var.database_name
  schema   = var.schema_name
  name     = "GET_USER_ORDER_HISTORY"
  comment  = "Returns order history for a specific user"

  language = "SQL"

  arguments {
    name = "USER_ID_PARAM"
    type = "NUMBER(38,0)"
  }

  return_type = "TABLE(ORDER_ID NUMBER(38,0), TOTAL_AMOUNT DECIMAL(10,2), STATUS VARCHAR(50), CREATED_AT TIMESTAMP_NTZ)"

  statement = <<-SQL
    DECLARE
        result_cursor CURSOR FOR 
            SELECT ID, TOTAL_AMOUNT, STATUS, CREATED_AT 
            FROM ${var.database_name}.${var.schema_name}.${snowflake_table.orders.name}
            WHERE USER_ID = USER_ID_PARAM
            ORDER BY CREATED_AT DESC;
    BEGIN
        OPEN result_cursor;
        RETURN TABLE(result_cursor);
    END;
  SQL

  depends_on = [snowflake_table.orders]
}