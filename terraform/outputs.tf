output "database_name" {
  description = "Name of the created database"
  value       = snowflake_database.main.name
}

output "warehouse_name" {
  description = "Name of the created warehouse"
  value       = snowflake_warehouse.main.name
}

output "schemas" {
  description = "Created schemas"
  value       = [for schema in snowflake_schema.schemas : schema.name]
}

output "app_role_name" {
  description = "Application role name"
  value       = snowflake_role.app_role.name
}

output "read_role_name" {
  description = "Read role name"
  value       = snowflake_role.read_role.name
}

output "resource_monitor_name" {
  description = "Resource monitor name (prod only)"
  value       = var.environment == "prod" ? snowflake_resource_monitor.main[0].name : null
}

# Module outputs
output "users_table_name" {
  description = "Name of the users table"
  value       = module.users.users_table_name
}

output "products_table_name" {
  description = "Name of the products table"
  value       = module.products.products_table_name
}

output "orders_table_name" {
  description = "Name of the orders table"
  value       = module.orders.orders_table_name
}

output "views" {
  description = "Available views"
  value       = module.views.view_names
}