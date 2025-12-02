variable "database_name" {
  description = "Name of the Snowflake database"
  type        = string
}

variable "schema_name" {
  description = "Name of the Snowflake schema"
  type        = string
}

variable "users_table_name" {
  description = "Full qualified name of users table for foreign key reference"
  type        = string
}