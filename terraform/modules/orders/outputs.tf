output "orders_table" {
  description = "Orders table resource"
  value       = snowflake_table.orders
}

output "orders_table_name" {
  description = "Full qualified name of orders table"
  value       = snowflake_table.orders.name
}

output "get_user_order_history_procedure" {
  description = "Get user order history procedure resource"
  value       = snowflake_procedure.get_user_order_history
}