# User orders summary view
resource "snowflake_view" "user_orders_summary" {
  database = var.database_name
  schema   = var.schema_name
  name     = "USER_ORDERS_SUMMARY"
  comment  = "Summary view of user orders with aggregated statistics"

  statement = <<-SQL
    SELECT 
        u.ID as USER_ID,
        u.EMAIL,
        u.FIRST_NAME,
        u.LAST_NAME,
        COUNT(o.ID) as TOTAL_ORDERS,
        SUM(o.TOTAL_AMOUNT) as TOTAL_SPENT,
        AVG(o.TOTAL_AMOUNT) as AVG_ORDER_VALUE,
        MAX(o.CREATED_AT) as LAST_ORDER_DATE
    FROM ${var.users_table_name} u
    LEFT JOIN ${var.orders_table_name} o ON u.ID = o.USER_ID
    GROUP BY u.ID, u.EMAIL, u.FIRST_NAME, u.LAST_NAME
  SQL
}