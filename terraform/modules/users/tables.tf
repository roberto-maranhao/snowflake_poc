# Users table definition
resource "snowflake_table" "users" {
  database = var.database_name
  schema   = var.schema_name
  name     = "USERS"
  comment  = "Application users table"

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
    identity {
      start_num = 1
      step_num  = 1
    }
  }

  column {
    name     = "EMAIL"
    type     = "VARCHAR(255)"
    nullable = false
  }

  column {
    name     = "FIRST_NAME"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "LAST_NAME"
    type     = "VARCHAR(100)"
    nullable = true
  }

  column {
    name     = "CREATED_AT"
    type     = "TIMESTAMP_NTZ"
    nullable = false
    default {
      constant = "CURRENT_TIMESTAMP()"
    }
  }

  column {
    name     = "UPDATED_AT"
    type     = "TIMESTAMP_NTZ"
    nullable = false
    default {
      constant = "CURRENT_TIMESTAMP()"
    }
  }
}

# Primary key constraint on users table
resource "snowflake_table_constraint" "users_primary_key" {
  name     = "PK_USERS"
  type     = "PRIMARY KEY"
  table_id = "${var.database_name}.${var.schema_name}.${snowflake_table.users.name}"
  columns  = ["ID"]
}

# Unique constraint on users email
resource "snowflake_table_constraint" "users_email_unique" {
  name     = "UQ_USERS_EMAIL"
  type     = "UNIQUE"
  table_id = "${var.database_name}.${var.schema_name}.${snowflake_table.users.name}"
  columns  = ["EMAIL"]
}