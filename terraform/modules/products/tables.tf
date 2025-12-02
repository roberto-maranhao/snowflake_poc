# Products table definition
resource "snowflake_table" "products" {
  database = var.database_name
  schema   = var.schema_name
  name     = "PRODUCTS"
  comment  = "Products catalog table"

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
    name     = "NAME"
    type     = "VARCHAR(255)"
    nullable = false
  }

  column {
    name     = "DESCRIPTION"
    type     = "TEXT"
    nullable = true
  }

  column {
    name     = "PRICE"
    type     = "NUMBER(10,2)"
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

  primary_key {
    name = "PK_PRODUCTS"
    keys = ["ID"]
  }
}