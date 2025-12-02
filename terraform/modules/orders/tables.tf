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
}

# Primary key constraint on orders table
resource "snowflake_table_constraint" "orders_primary_key" {
  name     = "PK_ORDERS"
  type     = "PRIMARY KEY"
  table_id = "${var.database_name}.${var.schema_name}.${snowflake_table.orders.name}"
  columns  = ["ID"]
}

# Foreign key constraint to users table
resource "snowflake_table_constraint" "orders_user_fk" {
  name     = "FK_ORDERS_USER_ID"
  type     = "FOREIGN KEY"
  table_id = "${var.database_name}.${var.schema_name}.${snowflake_table.orders.name}"
  columns  = ["USER_ID"]
  foreign_key_properties {
    references {
      table_id = "${var.database_name}.${var.schema_name}.${var.users_table_name}"
      columns  = ["ID"]
    }
  }
}