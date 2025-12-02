output "products_table" {
  description = "Products table resource"
  value       = snowflake_table.products
}

output "products_table_name" {
  description = "Full qualified name of products table"
  value       = snowflake_table.products.qualified_name
}

output "calculate_tax_function" {
  description = "Calculate tax function resource"
  value       = snowflake_function.calculate_order_total_with_tax
}

output "calculate_default_tax_function" {
  description = "Calculate default tax function resource"
  value       = snowflake_function.calculate_order_total_with_default_tax
}