# Orders table definition
resource "snowflake_table" "orders" {
  database = var.database_name
  schema   = var.schema_name
  name     = "ORDERS"
  comment  = "Customer orders table"

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
    name     = "USER_ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "TOTAL_AMOUNT"
    type     = "NUMBER(10,2)"
    nullable = true
  }

  column {
    name     = "STATUS"
    type     = "VARCHAR(50)"
    nullable = true
    default {
      constant = "'pending'"
    }
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

  primary_key {
    name = "PK_ORDERS"
    keys = ["ID"]
  }

  # Foreign key constraint to users table
  foreign_key {
    name           = "FK_ORDERS_USER_ID"
    columns        = ["USER_ID"]
    referenced_table_name   = var.users_table_name
    referenced_columns      = ["ID"]
  }
}