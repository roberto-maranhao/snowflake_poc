output "user_orders_summary_view" {
  description = "User orders summary view resource"
  value       = snowflake_view.user_orders_summary
}

output "user_orders_summary_view_name" {
  description = "Full qualified name of user orders summary view"
  value       = snowflake_view.user_orders_summary.name
}