variable "database_name" {
  description = "Name of the Snowflake database"
  type        = string
}

variable "schema_name" {
  description = "Name of the Snowflake schema"
  type        = string
}

variable "users_table_name" {
  description = "Full qualified name of users table"
  type        = string
}

variable "orders_table_name" {
  description = "Full qualified name of orders table"
  type        = string
}

variable "products_table_name" {
  description = "Full qualified name of products table"
  type        = string
}