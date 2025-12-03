output "users_table" {
  description = "Users table resource"
  value       = snowflake_table.users
}

output "users_table_name" {
  description = "Full qualified name of users table"
  value       = snowflake_table.users.name
}

output "create_user_procedure" {
  description = "Create user procedure resource"
  value       = snowflake_procedure_sql.create_user
}